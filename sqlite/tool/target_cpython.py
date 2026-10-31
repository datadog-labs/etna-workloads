"""CPython target for the etna pipeline (ETNA_KIND=cpython).

Imported at the end of sqlite_etna.py; every public name here replaces the
SQLite one, so the shared stages use CPython's build and test runner.

  build    the base is built once (./configure --with-pydebug; make). A
           candidate's build starts from a copy of that build tree with the
           changed source files swapped in: a hard-link copy and no make when
           only Lib/*.py changed (./python imports Lib/ from the tree), a
           real copy and an incremental make when C changed. A tree that is
           not derived from the base (the anchor's old revisions) gets a full
           build. The "testfixture" path is the tree's ./python.
  tests    ./python -m test -v <module> (regrtest: resources as below), run
           twice; a case passes when it passed in either run ("ok") and
           passes stably when it passed in both ("ok_all"). Case names are
           unittest ids, e.g. test.test_json.test_decode.TestDecode.test_x.
  mining   gh-/bpo- referenced fixes with fix wording; [3.x] backports of a
           main-branch commit are skipped (duplicates).
"""

import os
import re
import shutil
import subprocess
import time
from pathlib import Path

NAME = "CPython"
IMPL_DESC = ("Objects/, Python/, Parser/, Modules/, Include/ (C), Grammar/ and Lib/ (Python; "
             "not Lib/test/ or other test packages). When a generated file is checked in "
             "(Python/generated_cases.c.h, clinic/*.c.h, Parser/parser.c), keep it consistent with "
             "its source (make regen-cases, make clinic, make regen-pegen)")
# Checked-in generated sources count as implementation: a fix that changes
# Python/bytecodes.c also changes Python/generated_cases.c.h, and a parser fix
# changes Grammar/python.gram and Parser/parser.c; reversing only half of it
# leaves the build inconsistent.
IMPL = re.compile(r"^((Objects|Python|Parser|Modules|Include)/.*\.(c|h)|Lib/.*\.py|Grammar/.*\.(gram|tokens)|"
                  r"Parser/asdl_c\.py|Parser/Python\.asdl)$")
NOT_IMPL = re.compile(r"(^Modules/_test|/_testcapi|/_testinternal|^Lib/test/|/idle_test/|/tests?/|^Lib/idlelib/)")
TESTFILE = re.compile(r"^Lib/test/(?!support/|libregrtest/|.*data/).*\.py$")
# gh-/bpo- reference and fix wording, not a "[3.x]" backport.
FIXWORD = re.compile(r"^(?!\[\d)(?=.*\b(?:gh|GH|bpo)-\d+)(?=.*(?:\bfix|\bbugs?\b|crash|segfault|incorrect|"
                     r"wrong|regression|leak|race|deadlock|overflow|hang|invalid|broken|assert|error))", re.I)
TESTCASE = re.compile(r"^\+\s*(?:async\s+)?def (test_\w+)\s*\(")
REPORT = re.compile(r"\b((?:gh|bpo)-\d+)", re.I)
MINE_MERGES = False
NEWS_FIX = re.compile(r"^Misc/NEWS\.d/next/(Library|Core_and_Builtins|Core and Builtins|Security|C_API)/")
REF = re.compile(r"\b(?:gh|GH|bpo)-\d+")


def is_fix(c, body):
    """A gh-/bpo- referenced commit (not a [3.x] backport) with fix wording, or
    with a NEWS entry in a category where bug fixes are recorded. Features
    that pass are dropped by triage."""
    s = c["subject"]
    if s.startswith("[") or not REF.search(s):
        return False
    return bool(FIXWORD.search(s)) or any(NEWS_FIX.match(f) for f in c["files"])

RESOURCES = "all,-network,-urlfetch,-gui,-largefile,-audio,-cpu,-tzdata,-walltime"
CASE = re.compile(r"^(\w+) \(([\w.]+)\)(?:\n.*?)?\s\.\.\.\s(ok|FAIL|ERROR|skipped.*|expected failure|"
                  r"unexpected success)\s*$", re.M)
LINE = re.compile(r"^(test\w*) \(([\w.]+)\)")
RESULT = re.compile(r"^(?:== Tests result: |Result: )(\w+)", re.M)
C_PART = re.compile(r"\.(c|h)$")


def _E():
    import sqlite_etna as E
    return E


def testcase_name(m):
    return m.group(1)


def base_paths():
    E = _E()
    return E.WORK / "base-src", E.WORK / "base-build" / "python"


def _changed_files(base_src, tree):
    """Implementation and test files of tree that differ from the base."""
    out = []
    r = subprocess.run(["diff", "-rq", str(base_src), str(tree)], capture_output=True, text=True,
                       errors="replace")
    for line in r.stdout.splitlines():
        m = re.match(r"Files (\S+) and (\S+) differ", line) or re.match(r"Only in (\S+): (\S+)", line)
        if not m:
            continue
        if line.startswith("Files"):
            out.append(os.path.relpath(m.group(2), tree))
        elif m.group(1).startswith(str(tree)):
            out.append(os.path.relpath(os.path.join(m.group(1), m.group(2)), tree))
    # Source files only: agents' sandboxes leave hidden directories (.claude/)
    # in the tree, and only Lib/ and the C sources matter to the build.
    src = re.compile(r"^(Lib|Objects|Python|Parser|Modules|Include|Grammar)/")
    return [f for f in out if src.match(f) and not any(p.startswith(".") for p in f.split("/"))
            and ((Path(tree) / f).is_file() or not (Path(tree) / f).exists())]


def _full_build(bdir, jobs, env):
    E = _E()
    log = ""
    for cfg in (["./configure", "--with-pydebug"], ["./configure", "--with-pydebug", "--without-ensurepip"]):
        r = E.run(cfg, cwd=bdir, check=False, env=env, timeout=3600)
        if r.returncode:
            log = r.stdout[-2000:] + r.stderr[-2000:]
            continue
        r = E.run(["make", f"-j{jobs}"], cwd=bdir, check=False, env=env, timeout=7200)
        if (bdir / "python").exists():
            return bdir / "python", ""
        log = r.stdout[-3000:] + r.stderr[-3000:]
    return None, log


def build_testfixture(src_tree, bdir, jobs=2):
    E = _E()
    t0 = time.time()
    env = {**os.environ, "CC": "ccache gcc", "CCACHE_BASEDIR": str(bdir),
           "CCACHE_DIR": os.environ.get("CCACHE_DIR", str(E.WORK / "ccache"))}
    base_src, base_py = base_paths()
    base_build = base_py.parent
    if bdir.exists():
        shutil.rmtree(bdir)
    bdir.parent.mkdir(parents=True, exist_ok=True)
    changed = None
    if Path(bdir).resolve() != base_build.resolve() and base_py.exists():
        changed = _changed_files(base_src, src_tree)
        if len(changed) > 300:          # not derived from the base: an old revision
            changed = None
    if changed is None:
        shutil.copytree(src_tree, bdir, symlinks=True)
        py, log = _full_build(bdir, max(jobs, 4), env)
        return py, time.time() - t0, log
    has_c = any(C_PART.search(f) for f in changed)
    # Python-only: hard links are safe (patching replaces files; .pyc files are
    # written by rename). C: a real copy, since make writes objects in place.
    # Skip build/test_python_*: regrtest's worker directories live under the
    # configure-time build dir (the base build), and come and go mid-copy.
    shutil.copytree(base_build, bdir, symlinks=True,
                    ignore=shutil.ignore_patterns("test_python_*"),
                    copy_function=shutil.copy2 if has_c else os.link)
    for f in changed:
        dst = bdir / f
        if dst.exists() or dst.is_symlink():
            dst.unlink()
        if (src_tree / f).exists():
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src_tree / f, dst)
    if has_c:
        r = E.run(["make", f"-j{jobs}"], cwd=bdir, check=False, env=env, timeout=3600)
        if r.returncode or not (bdir / "python").exists():
            return None, time.time() - t0, r.stdout[-3000:] + r.stderr[-3000:]
    return bdir / "python", time.time() - t0, ""


def _module(testfile):
    m = re.sub(r"^Lib/", "", testfile)
    m = re.sub(r"(/__init__)?\.py$", "", m).replace("/", ".")
    return re.sub(r"^test\.", "", m)          # regrtest names: test_json.test_decode


def _run_once(py, module):
    E = _E()
    root = Path(py).parent
    cmd = [str(py), "-m", "test", "-v", "--timeout", "600", "-u", RESOURCES, module]
    p = subprocess.Popen(cmd, cwd=root, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                         start_new_session=True, env={**os.environ, "PYTHONHASHSEED": "0"})
    try:
        raw, _ = p.communicate(timeout=E.TEST_TIMEOUT)
        rc, timeout = p.returncode, False
    except subprocess.TimeoutExpired:
        os.killpg(p.pid, 9)
        raw, _ = p.communicate()
        rc, timeout = None, True
    out = raw.decode("utf-8", "replace")
    ok, failed = set(), set()
    for line in out.splitlines():
        m = LINE.match(line)
        if not m:
            continue
        name = m.group(2)
        if line.rstrip().endswith("... ok") or line.rstrip().endswith(" ok"):
            ok.add(name)
        elif re.search(r"\.\.\. (FAIL|ERROR)\s*$", line) or line.rstrip().endswith("unexpected success"):
            failed.add(name)
    # A case whose output spans lines ends with "... ok" / "FAIL" later on.
    for m in CASE.finditer(out):
        (ok if m.group(3) == "ok" else failed if m.group(3) in ("FAIL", "ERROR", "unexpected success")
         else set()).add(m.group(2))
    for m in re.finditer(r"^(?:FAIL|ERROR): (\w+) \(([\w.]+)\)", out, re.M):
        failed.add(m.group(2))
    res = RESULT.findall(out)
    complete = bool(res) and not timeout and res[-1] in ("SUCCESS", "FAILURE")
    return ok - failed, failed, complete, rc, timeout, out


def run_testfile(py, tree, testfile):
    t0 = time.time()
    root = Path(py).parent
    if not (root / testfile).exists():
        return {"ok": [], "ok_all": [], "failed": [], "complete": False, "rc": None,
                "timeout": False, "seconds": 0, "tail": f"{testfile} missing"}
    module = _module(testfile)
    a = _run_once(py, module)
    b = _run_once(py, module)
    ok_any, ok_all = a[0] | b[0], a[0] & b[0]
    failed = (a[1] | b[1]) - ok_any
    complete = a[2] and b[2]
    tail = "" if complete and not failed else (a[5][-1500:] if a[1] or not a[2] else b[5][-1500:])
    return {"ok": sorted(ok_any), "ok_all": sorted(ok_all), "failed": sorted(failed),
            "complete": complete, "rc": [a[3], b[3]], "timeout": a[4] or b[4],
            "seconds": round(time.time() - t0, 1), "tail": tail}


def oracle_of(c, base_runs):
    o = {}
    for f in c["test_files"]:
        br = base_runs.get(f)
        if br and br.get("complete") and br.get("ok_all"):
            o[f] = br["ok_all"]
    return o


def added_by_fix(c, failing):
    out = {}
    for f, names in failing.items():
        added = set(c["added_tests"].get(f, []))
        hit = [n for n in names if n.rsplit(".", 1)[-1] in added]
        if hit:
            out[f] = hit
    return out
