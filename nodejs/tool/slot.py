"""Worker-slot operations: apply/revert an injection, build, store the patch, check pristine.

A slot is a full source tree built in place at a fixed path (see mkslot.sh).
Injections touch implementation files only; every revert is verified byte for
byte against the pristine release tree.
"""
import filecmp, os, re, subprocess

W = os.environ.get("NODE_ETNA_WORK", os.path.expanduser("~/node-etna-work"))
PRISTINE = os.path.join(W, "pristine")
SCOPE = ("lib/", "src/")
CCACHE_ENV = {"CCACHE_DIR": os.path.join(W, "ccache"), "CCACHE_BASEDIR": W,
              "CCACHE_NOHASHDIR": "1"}


def is_impl(path):
    return path.startswith(SCOPE)


def patch_files(patch):
    """Files touched by a unified diff (paths without a/ b/)."""
    files = set()
    for m in re.finditer(r"^(?:---|\+\+\+) (?:[ab]/)?(\S+)", patch, re.M):
        if m.group(1) != "/dev/null":
            files.add(m.group(1))
    return sorted(files)


def apply(slot, diff, reverse=False, fuzz=True):
    """Apply a unified diff in slot. Returns 'clean', 'fuzzy' or None."""
    args = ["-R"] if reverse else []
    r = subprocess.run(["git", "apply", *args, "-"], cwd=slot, input=diff, capture_output=True)
    if r.returncode == 0:
        return "clean"
    if not fuzz:
        return None
    r = subprocess.run(["patch", "-p1", "-N", "-s", "-F2", "--dry-run", *args], cwd=slot,
                       input=diff, capture_output=True)
    if r.returncode != 0:
        return None
    r = subprocess.run(["patch", "-p1", "-N", "-s", "-F2", "--no-backup-if-mismatch", *args],
                       cwd=slot, input=diff, capture_output=True)
    return "fuzzy" if r.returncode == 0 else None


def make_patch(slot, files):
    """Stored injection = diff from the pristine release to the slot for `files`."""
    out = []
    for f in sorted(files):
        a, b = os.path.join(PRISTINE, f), os.path.join(slot, f)
        la = f"a/{f}" if os.path.exists(a) else "/dev/null"
        lb = f"b/{f}" if os.path.exists(b) else "/dev/null"
        r = subprocess.run(["diff", "-uN", "--label", la, "--label", lb,
                            a if os.path.exists(a) else "/dev/null",
                            b if os.path.exists(b) else "/dev/null"],
                           capture_output=True)
        if r.returncode == 1:
            out.append(f"diff -uN {la} {lb}\n".encode() + r.stdout)
        elif r.returncode > 1:
            raise RuntimeError(r.stderr.decode())
    return b"".join(out)


def restore(slot, files):
    """Force files back to pristine content (used only after a failed/partial apply)."""
    import shutil
    for f in files:
        a, b = os.path.join(PRISTINE, f), os.path.join(slot, f)
        if os.path.exists(a):
            os.makedirs(os.path.dirname(b), exist_ok=True)
            if os.path.exists(b):
                os.chmod(b, 0o644)
            shutil.copyfile(a, b)
        elif os.path.exists(b):
            os.remove(b)
        for ext in (".orig", ".rej"):
            if os.path.exists(b + ext):
                os.remove(b + ext)


def matches_pristine(slot, files):
    bad = []
    for f in files:
        a, b = os.path.join(PRISTINE, f), os.path.join(slot, f)
        if os.path.exists(a) != os.path.exists(b):
            bad.append(f)
        elif os.path.exists(a) and not filecmp.cmp(a, b, shallow=False):
            bad.append(f)
        if os.path.exists(b + ".orig") or os.path.exists(b + ".rej"):
            bad.append(f + ".orig/.rej")
    return bad


def require_pristine(slot):
    """Refuse to work in a slot whose lib/ or src/ differ from the release."""
    d = scope_drift(slot)
    if d:
        raise RuntimeError(f"slot {slot} is not pristine; refusing to run:\n{d[:1000]}")


def scope_drift(slot):
    """All files under lib/ and src/ that differ from pristine (slow; used for audits)."""
    r = subprocess.run(["diff", "-rq", "--no-dereference", os.path.join(PRISTINE, "lib"),
                        os.path.join(slot, "lib")], capture_output=True, text=True)
    r2 = subprocess.run(["diff", "-rq", "--no-dereference", os.path.join(PRISTINE, "src"),
                         os.path.join(slot, "src")], capture_output=True, text=True)
    return (r.stdout + r2.stdout).strip()


BUILD_LOCK_FILE = os.path.join(W, "harness-build.lock")


def build(slot, cctest=False, jobs=16, log=None):
    """Incremental build; harness builds are serialised host-wide (across processes)."""
    import fcntl
    with open(BUILD_LOCK_FILE, "w") as lk:
        fcntl.flock(lk, fcntl.LOCK_EX)
        return _build(slot, cctest, jobs, log)


def _build(slot, cctest=False, jobs=16, log=None):
    env = dict(os.environ, **CCACHE_ENV)
    cmds = [["make", f"-j{jobs}"]]
    if cctest:
        cmds.append(["make", f"-j{jobs}", "-C", "out", "BUILDTYPE=Release", "cctest"])
    out = b""
    for c in cmds:
        r = subprocess.run(c, cwd=slot, env=env, capture_output=True)
        out += r.stdout + r.stderr
        if r.returncode != 0:
            if log:
                open(log, "wb").write(out[-200000:])
            return False
    return True
