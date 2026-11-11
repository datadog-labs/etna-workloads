"""Build slots, test runner and parser for Z3 (clean-room tooling).

Layout (all under ~/z3-etna-work):
  base/src      pristine release source (read-only)
  base/build    base build (read-only after build)
  slots/sN/src  per-slot source copy (content-synced from base/src with rsync -rlpc)
  slots/sN/build  per-slot incremental build (configured once against slots/sN/src)
  runs/         private per-run temp dirs (deleted after each run)
"""
import os, re, subprocess, signal, shutil, tempfile, time, json, resource, hashlib
from common import *

BASE = os.path.join(WORK, "base")
BASE_SRC = os.path.join(BASE, "src")
BASE_BUILD = os.path.join(BASE, "build")
SLOTS = os.path.join(WORK, "slots")
RUNS = os.path.join(WORK, "runs")
MEM_LIMIT = 8 * 1024 ** 3          # per-process address-space limit for builds and tests
BUILD_MEM_LIMIT = 6 * 1024 ** 3
CMAKE_FLAGS = ["-G", "Ninja", "-DCMAKE_BUILD_TYPE=Debug", "-DCMAKE_CXX_FLAGS_DEBUG=-O1 -g0",
               "-DCMAKE_C_FLAGS_DEBUG=-O1 -g0",
               "-DZ3_INCLUDE_GIT_HASH=OFF", "-DZ3_INCLUDE_GIT_DESCRIBE=OFF",
               "-DZ3_BUILD_TEST_EXECUTABLES=ON"]
TARGETS = ["z3", "test-z3"]


def _limits(mem):
    def f():
        os.setsid()
        resource.setrlimit(resource.RLIMIT_AS, (mem, mem))
        resource.setrlimit(resource.RLIMIT_CORE, (0, 0))
    return f


def run_limited(cmd, cwd, timeout, mem=MEM_LIMIT, stdout=None, env=None):
    """Run cmd in its own process group with an address-space limit; kill the group on timeout.
    Returns (rc, output, timed_out, secs)."""
    t0 = time.time()
    p = subprocess.Popen(cmd, cwd=cwd, stdin=subprocess.DEVNULL, stdout=subprocess.PIPE,
                         stderr=subprocess.STDOUT, preexec_fn=_limits(mem), env=env)
    timed_out = False
    try:
        out, _ = p.communicate(timeout=timeout)
    except subprocess.TimeoutExpired:
        timed_out = True
        try: os.killpg(p.pid, signal.SIGKILL)
        except ProcessLookupError: pass
        out, _ = p.communicate()
    # whatever happened, nothing in the group may survive
    try: os.killpg(p.pid, signal.SIGKILL)
    except ProcessLookupError: pass
    return p.returncode, out.decode("utf-8", "replace"), timed_out, time.time() - t0


RETRYABLE_RE = re.compile(r"No space left on device|Disk quota exceeded|Read-only file system")


def parse_unit(rc, out, timed_out):
    """Classify one test-z3 single-unit run.  pass iff exit 0 and a 'PASS' line is printed.
    Returns (status, detail) where status in pass|fail|error (error = retryable infra problem)."""
    if RETRYABLE_RE.search(out):
        return "error", "disk"
    if timed_out:
        return "fail", "timeout"
    lines = [l.strip() for l in out.splitlines()]
    if rc == 0 and "PASS" in lines:
        return "pass", ""
    if "ASSERTION VIOLATION" in out:
        m = re.search(r"ASSERTION VIOLATION\s*\nFile: (\S+)\s*\nLine: (\d+)", out)
        return "fail", "assert:" + (os.path.basename(m.group(1)) + ":" + m.group(2) if m else "?")
    if "UNREACHABLE" in out or "NOT IMPLEMENTED YET" in out:
        return "fail", "unreachable"
    if re.search(r"out of memory|std::bad_alloc", out):
        return "fail", "oom"
    if rc is not None and rc < 0:
        return "fail", f"signal:{-rc}"
    return "fail", f"rc:{rc}"


def run_unit(build, unit, timeout=600):
    os.makedirs(RUNS, exist_ok=True)
    d = tempfile.mkdtemp(prefix=f"{unit}.", dir=RUNS)
    try:
        rc, out, to, secs = run_limited([os.path.join(build, "test-z3"), unit], d, timeout,
                                        env=dict(os.environ, TMPDIR=d))
    finally:
        shutil.rmtree(d, ignore_errors=True)
    st, det = parse_unit(rc, out, to)
    return dict(unit=unit, status=st, detail=det, rc=rc, secs=round(secs, 1), tail=out[-1500:])


def run_smt2(build, smt2, timeout=60, args=("model_validate=true",)):
    """Run z3 on one .smt2 file the way z3test does; returns (rc, combined output, timed_out)."""
    os.makedirs(RUNS, exist_ok=True)
    d = tempfile.mkdtemp(prefix="smt2.", dir=RUNS)
    try:
        shutil.copy(smt2, os.path.join(d, "in.smt2"))
        rc, out, to, secs = run_limited([os.path.join(build, "z3"), *args, "in.smt2"], d, timeout,
                                        env=dict(os.environ, TMPDIR=d))
    finally:
        shutil.rmtree(d, ignore_errors=True)
    return rc, out, to


# ---------------------------------------------------------------- build
def configure(src, build, log, extra=()):
    os.makedirs(build, exist_ok=True)
    rc, out, to, _ = run_limited(["cmake", "-S", src, "-B", build, *CMAKE_FLAGS, *extra], build, 900,
                                 mem=BUILD_MEM_LIMIT)
    open(log, "a").write(out)
    return rc == 0 and not to


def ninja(build, log, jobs=6, timeout=5400, targets=TARGETS):
    rc, out, to, secs = run_limited(["ninja", "-C", build, f"-j{jobs}", *targets], build, timeout,
                                    mem=BUILD_MEM_LIMIT, env=dict(os.environ, PYTHONDONTWRITEBYTECODE="1"))
    open(log, "a").write(out[-200000:])
    if RETRYABLE_RE.search(out):
        return "error", secs
    return ("ok" if rc == 0 and not to else ("timeout" if to else "fail")), secs


def sync_src(src_from, src_to):
    """Content-based sync without preserving mtimes (changed files get a fresh mtime)."""
    os.makedirs(src_to, exist_ok=True)
    subprocess.run(["rsync", "-rlpc", "--chmod=u+w", "--delete", src_from.rstrip("/") + "/", src_to], check=True)


def slot_paths(n):
    s = os.path.join(SLOTS, f"s{n}")
    return s, os.path.join(s, "src"), os.path.join(s, "build")


def ensure_slot(n, log):
    """Create slot n (copy of base src, own configured build) if needed. Returns (src, build)."""
    s, src, build = slot_paths(n)
    if not os.path.exists(os.path.join(build, "build.ninja")) or not os.path.exists(os.path.join(s, "ready")):
        shutil.rmtree(s, ignore_errors=True)
        os.makedirs(s)
        sync_src(BASE_SRC, src)
        if not configure(src, build, log):
            raise RuntimeError("slot configure failed")
        st, _ = ninja(build, log)
        if st != "ok":
            raise RuntimeError(f"slot base build {st}")
        open(os.path.join(s, "ready"), "w").write("ok")
    return src, build


def reset_slot(n):
    s, src, build = slot_paths(n)
    sync_src(BASE_SRC, src)


# ---------------------------------------------------------------- patches
def impl_diff(sha, files=None, cwd=REPO):
    """Implementation-only diff of a commit (files in SCOPE)."""
    if files is None:
        files = [f for f in git("diff", "--name-only", f"{sha}^", sha, cwd=cwd).split() if is_impl(f)]
    if not files:
        return ""
    return git("diff", "--no-color", f"{sha}^", sha, "--", *files, cwd=cwd)


def apply_patch(tree, patch, reverse=False):
    """Apply a patch to a plain tree: exact git apply, then -C1, then GNU patch with fuzz.
    Returns 'exact' | 'fuzzy' | None."""
    rev = ["-R"] if reverse else []
    for mode, cmd in (("exact", ["git", "apply", *rev]),
                      ("fuzzy", ["git", "apply", *rev, "-C1"])):
        r = subprocess.run(cmd + ["--check"], cwd=tree, input=patch, text=True, capture_output=True)
        if r.returncode == 0:
            subprocess.run(cmd, cwd=tree, input=patch, text=True, capture_output=True, check=True)
            return mode
    r = subprocess.run(["patch", *rev, "-p1", "--dry-run", "-F3", "-s", "-f"], cwd=tree, input=patch,
                       text=True, capture_output=True)
    if r.returncode == 0:
        subprocess.run(["patch", *rev, "-p1", "-F3", "-s", "-f", "--no-backup-if-mismatch"], cwd=tree,
                       input=patch, text=True, capture_output=True, check=True)
        return "fuzzy"
    return None


def tree_diff(a_root, b_root, rels):
    """Unified diff a/ -> b/ over given relative paths (labels a/<rel>, b/<rel>; git apply -p1 compatible)."""
    out = []
    for rel in sorted(set(rels)):
        a, b = os.path.join(a_root, rel), os.path.join(b_root, rel)
        la = "a/" + rel if os.path.exists(a) else "/dev/null"
        lb = "b/" + rel if os.path.exists(b) else "/dev/null"
        r = subprocess.run(["diff", "-u", "--label", la, "--label", lb,
                            a if os.path.exists(a) else "/dev/null", b if os.path.exists(b) else "/dev/null"],
                           capture_output=True, text=True, errors="replace")
        if r.returncode == 1:
            out.append(r.stdout if r.stdout.endswith("\n") else r.stdout + "\n")
    return "".join(out)


def changed_files(base_root, tree_root, skip_symlinks=True):
    """Relative paths whose content differs between two trees (ignores symlinked paths)."""
    r = subprocess.run(["rsync", "-rlpcn", "--delete", "--out-format=%n", base_root.rstrip("/") + "/",
                        tree_root], capture_output=True, text=True)
    files = set()
    for l in r.stdout.splitlines():
        l = l.strip()
        if l.startswith("deleting "):
            l = l[len("deleting "):]
        if not l or l.endswith("/") or "__pycache__/" in l or l.endswith(".pyc") or os.path.basename(l) == ".z3-trace":
            continue  # byte-code caches written by the build's python generators
        files.add(l)
    out = []
    for f in files:
        p = os.path.join(tree_root, f)
        if skip_symlinks and _through_symlink(tree_root, f):
            continue
        out.append(f)
    return sorted(out)


def _through_symlink(root, rel):
    cur = root
    for part in rel.split("/"):
        cur = os.path.join(cur, part)
        if os.path.islink(cur):
            return True
    return False


def file_sha(p):
    return hashlib.sha256(open(p, "rb").read()).hexdigest()


def reverse_restores_base(tree, injection, files):
    """Gate check: reversing the stored injection in `tree` yields base bytes for every touched file."""
    tmp = tempfile.mkdtemp(prefix="revchk.", dir=RUNS)
    try:
        for f in files:
            src = os.path.join(tree, f)
            if os.path.exists(src):
                os.makedirs(os.path.dirname(os.path.join(tmp, f)), exist_ok=True)
                shutil.copyfile(src, os.path.join(tmp, f))
        r = subprocess.run(["git", "apply", "-R"], cwd=tmp, input=injection, text=True, capture_output=True)
        if r.returncode != 0:
            return False
        for f in files:
            a, b = os.path.join(BASE_SRC, f), os.path.join(tmp, f)
            if os.path.exists(a) != os.path.exists(b):
                return False
            if os.path.exists(a) and file_sha(a) != file_sha(b):
                return False
        return True
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


# ---------------------------------------------------------------- z3test cases
Z3TEST = os.path.join(WORK, "z3test-pinned", "regressions")


def run_z3test_case(build, rel, timeout=120):
    """z3test semantics: `z3 model_validate=true f.smt2`, stdout+stderr must equal f.expected.out
    and the exit code must be 0, 1 or 105."""
    smt2 = os.path.join(Z3TEST, rel)
    exp = open(smt2[:-5] + ".expected.out", errors="replace").read()
    rc, out, to = run_smt2(build, smt2, timeout)
    if RETRYABLE_RE.search(out):
        st, det = "error", "disk"
    elif to:
        st, det = "fail", "timeout"
    elif rc not in (0, 1, 105):
        st, det = "fail", f"rc:{rc}"
    elif out != exp:
        st, det = "fail", "output_mismatch"
    else:
        st, det = "pass", ""
    return dict(unit="z3test:" + rel, status=st, detail=det, rc=rc, secs=0, tail=out[-1500:])


def run_case(build, case, timeout):
    if case.startswith("z3test:"):
        return run_z3test_case(build, case[len("z3test:"):], timeout)
    return run_unit(build, case, timeout)
