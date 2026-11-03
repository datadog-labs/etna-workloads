"""Go compiler target for the etna pipeline (ETNA_KIND=go).

Imported at the end of sqlite_etna.py; every public name here replaces the
SQLite one, so the shared stages use Go's build and test runners.

  scope    the gc compiler: implementation in src/cmd/compile/ (not tests or
           testdata); fixes identified by a "Fixes #NNNNN" line
  build    the base is built once (src/make.bash, bootstrapped by
           $GOROOT_BOOTSTRAP). A candidate's build is a hard-link copy of the
           base build with the changed sources swapped in and only cmd/compile
           reinstalled; a tree not derived from the base (the anchor's old
           revisions) gets a full make.bash. The "testfixture" path is the
           tree's bin/go.
  tests    two kinds of unit:
             test/<path>.go        go test cmd/internal/testdir -run ^Test/<path>.go$
             pkg:<import path>     go test <import path> (cmd/compile packages,
                                   and cmd/compile/internal/types2 for
                                   src/internal/types/testdata)
           each run twice; a case passes when it passed in either run ("ok")
           and passes stably when it passed in both ("ok_all")
"""

import os
import re
import shutil
import subprocess
import time
from pathlib import Path

NAME = "Go"
IMPL_DESC = ("src/cmd/compile/ (Go sources, and the SSA rewrite rules in "
             "src/cmd/compile/internal/ssa/_gen/*.rules together with the generated rewrite*.go)")
IMPL = re.compile(r"^src/cmd/compile/(.*\.go|internal/ssa/_gen/.*\.rules)$")
NOT_IMPL = re.compile(r"(_test\.go$|/testdata/)")
TESTFILE = re.compile(r"^(test/.*\.go|test/.*\.dir/.*|src/cmd/compile/.*_test\.go|src/cmd/compile/.*/testdata/.*|"
                      r"src/internal/types/testdata/.*)$")
FIXWORD = re.compile(r"(^|\n)\s*Fixes\s+(golang/go)?#\d+", re.I)
TESTCASE = re.compile(r"^\+func (Test\w+)\(")
REPORT = re.compile(r"(?:golang/go)?#(\d{3,6})")
MINE_MERGES = False

BOOTSTRAP = os.environ.get("GOROOT_BOOTSTRAP", str(Path.home() / "go-bootstrap"))
RESULT = re.compile(r"^\s*--- (PASS|FAIL|SKIP): (\S+)", re.M)
SUMMARY = re.compile(r"^(ok|FAIL|---)\s+\S+", re.M)


def _E():
    import sqlite_etna as E
    return E


def testcase_name(m):
    return m.group(1)


def is_fix(c, body):
    return bool(FIXWORD.search(body))


def test_unit(f):
    m = re.match(r"^(test/.*)\.dir/", f)
    if m:
        return m.group(1) + ".go"                  # rundir test: the driver file
    if f.startswith("test/"):
        return f
    if f.startswith("src/internal/types/testdata/"):
        return "pkg:cmd/compile/internal/types2"
    m = re.match(r"^src/(cmd/compile/.*?)/(?:testdata/.*|[^/]+_test\.go)$", f)
    return "pkg:" + m.group(1) if m else f


def unit_exists(src, unit):
    if unit.startswith("pkg:"):
        return (src / "src" / unit[4:]).is_dir()
    return (src / unit).is_file()


def base_paths():
    E = _E()
    return E.WORK / "base-src", E.WORK / "base-build" / "bin" / "go"


CACHE = ".etna-gocache"


def _env(goroot=None):
    """A release toolchain identifies its compiler by version string, not by
    the binary's contents, so every injected compiler would share cache keys
    with the clean one: each tree gets its own build cache."""
    E = _E()
    cache = str(Path(goroot) / CACHE) if goroot else str(E.WORK / "gocache-bootstrap")
    env = {**os.environ, "GOROOT_BOOTSTRAP": BOOTSTRAP, "GOTOOLCHAIN": "local", "GOPROXY": "off",
           "GOFLAGS": "", "GOCACHE": cache, "GOPATH": str(E.WORK / "gopath"), "CGO_ENABLED": "1"}
    env.pop("GOROOT", None)                 # bin/go finds its own GOROOT
    return env


def _changed_files(base_src, tree):
    out = []
    r = subprocess.run(["diff", "-rq", str(base_src / "src" / "cmd" / "compile"),
                        str(Path(tree) / "src" / "cmd" / "compile")],
                       capture_output=True, text=True, errors="replace")
    for line in r.stdout.splitlines():
        m = re.match(r"Files (\S+) and (\S+) differ", line)
        if m:
            out.append(os.path.relpath(m.group(2), tree))
        m = re.match(r"Only in (\S+): (\S+)", line)
        if m and m.group(1).startswith(str(tree)):
            out.append(os.path.relpath(os.path.join(m.group(1), m.group(2)), tree))
    return [f for f in out if not any(p.startswith(".") for p in f.split("/"))
            and ((Path(tree) / f).is_file() or not (Path(tree) / f).exists())]


def _full_build(bdir, env):
    E = _E()
    if not (bdir / "VERSION").exists():
        # A tree exported from git has neither .git nor VERSION, and dist
        # refuses to build without a version.
        (bdir / "VERSION").write_text("devel etna-anchor\n")
    r = E.run(["./make.bash"], cwd=bdir / "src", check=False, env=env, timeout=3600)
    if r.returncode == 0 and (bdir / "bin" / "go").exists():
        return bdir / "bin" / "go", ""
    return None, r.stdout[-3000:] + r.stderr[-3000:]


def build_testfixture(src_tree, bdir, jobs=2):
    E = _E()
    t0 = time.time()
    base_src, base_go = base_paths()
    base_build = base_go.parent.parent
    if bdir.exists():
        shutil.rmtree(bdir)
    bdir.parent.mkdir(parents=True, exist_ok=True)
    env = _env(bdir)
    derived = Path(bdir).resolve() != base_build.resolve() and base_go.exists() and \
        (Path(src_tree) / "VERSION").exists() and \
        (Path(src_tree) / "VERSION").read_text() == (base_src / "VERSION").read_text()
    if not derived:
        shutil.copytree(src_tree, bdir, symlinks=True)
        go, log = _full_build(bdir, env)
        return go, time.time() - t0, log
    changed = _changed_files(base_src, src_tree)
    # Hard links are safe: patched files are replaced, and go install writes
    # the new compiler by rename.
    shutil.copytree(base_build, bdir, symlinks=True, copy_function=os.link,
                    ignore=shutil.ignore_patterns(CACHE))
    for f in changed:
        dst = bdir / f
        if dst.exists() or dst.is_symlink():
            dst.unlink()
        if (Path(src_tree) / f).exists():
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(Path(src_tree) / f, dst)
    if changed:
        r = E.run([str(bdir / "bin" / "go"), "install", "cmd/compile"], cwd=bdir / "src",
                  check=False, env=_env(bdir), timeout=1800)
        if r.returncode:
            return None, time.time() - t0, r.stdout[-3000:] + r.stderr[-3000:]
    return bdir / "bin" / "go", time.time() - t0, ""


def _run_once(go, unit):
    E = _E()
    root = Path(go).parent.parent
    if unit.startswith("pkg:"):
        cmd = [str(go), "test", unit[4:], "-v", "-count=1", "-timeout", "20m"]
    else:
        path = unit[len("test/"):]
        cmd = [str(go), "test", "cmd/internal/testdir", "-v", "-count=1", "-timeout", "20m",
               "-run", "^Test/" + re.escape(path) + "$"]
    p = subprocess.Popen(cmd, cwd=root / "src", stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                         start_new_session=True, env=_env(root))
    try:
        raw, _ = p.communicate(timeout=E.TEST_TIMEOUT)
        rc, timeout = p.returncode, False
    except subprocess.TimeoutExpired:
        os.killpg(p.pid, 9)
        raw, _ = p.communicate()
        rc, timeout = None, True
    out = raw.decode("utf-8", "replace")
    ok = {m.group(2) for m in RESULT.finditer(out) if m.group(1) == "PASS"}
    failed = {m.group(2) for m in RESULT.finditer(out) if m.group(1) == "FAIL"}
    complete = bool(SUMMARY.search(out)) and not timeout and "build failed" not in out
    return ok - failed, failed, complete, rc, timeout, out


def run_testfile(go, tree, unit):
    t0 = time.time()
    a = _run_once(go, unit)
    b = _run_once(go, unit)
    ok_any, ok_all = a[0] | b[0], a[0] & b[0]
    failed = (a[1] | b[1]) - ok_any
    complete = a[2] and b[2]
    tail = "" if complete and not failed else (a[5][-1500:] if a[1] or not a[2] else b[5][-1500:])
    return {"ok": sorted(ok_any), "ok_all": sorted(ok_all), "failed": sorted(failed),
            "complete": complete, "rc": [a[3], b[3]], "timeout": a[4] or b[4],
            "seconds": round(time.time() - t0, 1), "tail": tail}


def oracle_of(c, base_runs):
    o = {}
    for u in c["test_files"]:
        br = base_runs.get(u)
        if br and br.get("complete") and br.get("ok_all"):
            o[u] = br["ok_all"]
    return o


def added_by_fix(c, failing):
    """A failing case is the fix's own when it is the fix's test/ program, a
    test function the fix added, or a types2 testdata file the fix touched."""
    funcs = {n for names in c.get("added_tests", {}).values() for n in names}
    touched = {os.path.basename(f) for f in c.get("test_files_raw", [])}
    out = {}
    for u, names in failing.items():
        if not u.startswith("pkg:"):
            out[u] = names                                  # Test/<the fix's program>
            continue
        hit = [n for n in names if n.split("/")[0] in funcs
               or (len(n.split("/")) > 1 and os.path.basename(n.split("/")[-1]) in touched)]
        if hit:
            out[u] = hit
    return out


def _testdir_all(go):
    """One run of the whole test/ tree; returns ({case: status}, complete, out)."""
    E = _E()
    root = Path(go).parent.parent
    p = subprocess.Popen([str(go), "test", "cmd/internal/testdir", "-v", "-count=1", "-timeout", "60m"],
                         cwd=root / "src", stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                         start_new_session=True, env=_env(root))
    try:
        raw, _ = p.communicate(timeout=4 * 3600)
        timeout = False
    except subprocess.TimeoutExpired:
        os.killpg(p.pid, 9)
        raw, _ = p.communicate()
        timeout = True
    out = raw.decode("utf-8", "replace")
    status = {}
    for m in RESULT.finditer(out):
        status[m.group(2)] = m.group(1)
    return status, bool(SUMMARY.search(out)) and not timeout, out


def run_batch(go, tree, units, jobs):
    """Base runs: the test/ programs from two full testdir runs, split per
    program; package units individually, a few at a time."""
    from concurrent.futures import ThreadPoolExecutor
    t0 = time.time()
    tunits = [u for u in units if not u.startswith("pkg:")]
    punits = [u for u in units if u.startswith("pkg:")]
    out = []
    if tunits:
        a, ca, _ = _testdir_all(go)
        b, cb, _ = _testdir_all(go)
        secs = round((time.time() - t0) / max(1, len(tunits)), 1)
        for u in tunits:
            case = "Test/" + u[len("test/"):]
            names = [case, "TestShouldTest"]
            ok_a = {n for n in names if a.get(n) == "PASS"}
            ok_b = {n for n in names if b.get(n) == "PASS"}
            fail = {n for n in names if "FAIL" in (a.get(n), b.get(n))} - (ok_a | ok_b)
            seen = case in a and case in b
            out.append((u, {"ok": sorted(ok_a | ok_b), "ok_all": sorted(ok_a & ok_b), "failed": sorted(fail),
                            "complete": ca and cb and seen, "rc": None, "timeout": False,
                            "seconds": secs, "tail": "" if seen else f"{case} not run by testdir"}))
    with ThreadPoolExecutor(max(1, min(jobs, 3))) as ex:
        for u, r in zip(punits, ex.map(lambda u: run_testfile(go, tree, u), punits)):
            out.append((u, r))
    return out
