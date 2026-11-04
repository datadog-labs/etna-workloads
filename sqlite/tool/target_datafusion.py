"""DataFusion target for the etna pipeline (ETNA_KIND=datafusion).

Imported at the end of sqlite_etna.py; every public name here replaces the
SQLite one, so the shared stages use DataFusion's build and test runner.

  oracle   SQL logic test files (datafusion/sqllogictest/test_files/*.slt)
           only. Rust unit tests live in the same src/ files as the code, so
           reversing a fix's implementation would also delete the test it
           added; .slt files are never touched by an injection. A case is a
           whole .slt file: it passes when the file runs with no errors.
  build    worker slots at fixed paths (Cargo's fingerprints and sccache's
           keys contain absolute paths, so a tree copied elsewhere would
           rebuild everything). A slot keeps a tree and a target directory;
           a candidate's tree is rsynced in (only differing files change, so
           only the affected crates rebuild), the sqllogictests binary is
           built and copied out, and the slot is free for the next candidate
           while the tests run from the candidate's own tree.
"""

import fcntl
import os
import re
import shutil
import subprocess
import time
from pathlib import Path

NAME = "DataFusion"
IMPL_DESC = "datafusion/*/src/ (Rust sources of the crates; not tests, benches or examples)"
IMPL = re.compile(r"^datafusion/.*/src/.*\.rs$")
NOT_IMPL = re.compile(r"(/tests?/|_test\.rs$|/benches/|/examples/|^datafusion/sqllogictest/|/test_util|/testing/|"
                      r"^datafusion-examples/)")
TESTFILE = re.compile(r"^datafusion/sqllogictest/test_files/.*\.slt$")
FIXWORD = re.compile(r"\bfix|\bbugs?\b|panic|crash|incorrect|wrong|regression|invalid|overflow|broken|"
                     r"error|mismatch|unexpected", re.I)
TESTCASE = re.compile(r"^\+(query|statement)\b")
REPORT = re.compile(r"#(\d{3,6})")
MINE_MERGES = False

SLOTS = int(os.environ.get("ETNA_DF_SLOTS", "3"))
ERRFILE = re.compile(r"(\d+) errors in file (\S+)")
ERRAT = re.compile(r"^at (\S+\.slt):(\d+)", re.M)
SCCACHE = os.environ.get("ETNA_SCCACHE", str(Path.home() / ".local" / "bin" / "sccache"))


def _E():
    import sqlite_etna as E
    return E


def testcase_name(m):
    return "query"


TESTDATA = ("testing", "parquet-testing", "datafusion-testing")


def post_export(src):
    """git archive leaves the test-data submodules as empty directories; link
    them to the copies in WORK/testdata (shared, read-only, never synced)."""
    E = _E()
    for m in TESTDATA:
        p = Path(src) / m
        if p.is_symlink():
            continue
        if p.exists():
            shutil.rmtree(p)
        p.symlink_to(E.WORK / "testdata" / m)


def base_paths():
    E = _E()
    return E.WORK / "base-src", E.WORK / "base-build" / "sqllogictests"


def _env(target):
    E = _E()
    return {**os.environ, "RUSTC_WRAPPER": SCCACHE, "SCCACHE_DIR": str(E.WORK / "sccache"),
            "SCCACHE_CACHE_SIZE": "80G", "CARGO_PROFILE_DEV_DEBUG": "0", "CARGO_INCREMENTAL": "0",
            "CARGO_TARGET_DIR": str(target), "CARGO_TERM_COLOR": "never"}


class _Slot:
    """One of SLOTS fixed build locations, locked across processes. With
    preferred=k, wait for slot k (where a candidate was built: its build is
    then usually still there)."""

    def __init__(self, preferred=None):
        self.preferred = preferred

    def __enter__(self):
        E = _E()
        d = E.WORK / "slots"
        d.mkdir(parents=True, exist_ok=True)
        order = [self.preferred] if self.preferred is not None else range(SLOTS)
        while True:
            for k in order:
                f = open(d / f"{k}.lock", "w")
                try:
                    fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
                except BlockingIOError:
                    f.close()
                    continue
                self.f, self.k, self.dir = f, k, d / str(k)
                return self
            time.sleep(5)

    def __exit__(self, *exc):
        fcntl.flock(self.f, fcntl.LOCK_UN)
        self.f.close()


def _sync_tree(slot, tree):
    """Make the slot's tree equal to `tree`. Returns an error log or ""."""
    E = _E()
    src = slot.dir / "src"
    src.mkdir(parents=True, exist_ok=True)
    # Compare by content and do not keep times: Cargo rebuilds a crate only if
    # a source is newer than its last build, and git archive dates files at
    # the commit time, so a copied older revision (or a candidate's tree after
    # another's injection) would otherwise reuse the stale build.
    r = E.run(["rsync", "-rlpc", "--delete", "--exclude", "/target"] +
              sum((["--exclude", f"/{m}"] for m in TESTDATA), []) + [f"{tree}/", f"{src}/"],
              check=False, timeout=1800)
    if r.returncode:
        return "rsync: " + r.stderr[-1500:]
    post_export(src)                       # test data links (never synced)
    return ""


def _sync_build(slot, tree):
    """Make the slot's tree equal to `tree` and build sqllogictests there.
    Returns (exe or None, log). The runner normalizes paths against the
    compile-time CARGO_MANIFEST_DIR, so tests must run in this tree."""
    E = _E()
    src, target = slot.dir / "src", slot.dir / "target"
    err = _sync_tree(slot, tree)
    if err:
        return None, err
    r = E.run(["cargo", "test", "-p", "datafusion-sqllogictest", "--test", "sqllogictests", "--no-run"],
              cwd=src, check=False, env=_env(target), timeout=7200)
    log = r.stdout + r.stderr
    m = re.findall(r"Executable \S*sqllogictests\.rs \((\S+)\)", log)
    if r.returncode or not m:
        return None, log[-3000:]
    exe = Path(m[-1]) if Path(m[-1]).is_absolute() else src / m[-1]
    return exe, ""


def build_testfixture(src_tree, bdir, jobs=2):
    """Build src_tree in a slot (to find build failures); bdir records the
    tree and the slot. The returned path is a marker for run_testfile."""
    t0 = time.time()
    if bdir.exists():
        shutil.rmtree(bdir)
    bdir.mkdir(parents=True)
    with _Slot() as slot:
        exe, log = _sync_build(slot, Path(src_tree).resolve())
        if not exe:
            return None, time.time() - t0, log
        (bdir / "slot").write_text(str(slot.k))
    (bdir / "tree").symlink_to(Path(src_tree).resolve())
    (bdir / "sqllogictests").write_text("marker: see run_testfile\n")
    return bdir / "sqllogictests", time.time() - t0, ""


def _run_once(exe, slot_src, unit):
    E = _E()
    rel = unit[len("datafusion/sqllogictest/test_files/"):]
    cwd = slot_src / "datafusion" / "sqllogictest"
    shutil.rmtree(cwd / "test_files" / "scratch", ignore_errors=True)
    p = subprocess.Popen([str(exe), "--color", "never", "--test-threads", "8", rel], cwd=cwd,
                         stdout=subprocess.PIPE, stderr=subprocess.STDOUT, start_new_session=True)
    try:
        raw, _ = p.communicate(timeout=E.TEST_TIMEOUT)
        rc, timeout = p.returncode, False
    except subprocess.TimeoutExpired:
        os.killpg(p.pid, 9)
        raw, _ = p.communicate()
        rc, timeout = None, True
    out = raw.decode("utf-8", "replace")
    mine = lambda path: path.endswith("/test_files/" + rel)
    errors = [m for m in ERRFILE.finditer(out) if mine(m.group(2))]
    lines = {f"{unit}:{m.group(2)}" for m in ERRAT.finditer(out) if mine(m.group(1))}
    ran = "files completed" in out
    # Exit status 0: every selected file passed. Otherwise this file failed if
    # an error names it, or if the run died before reporting (a panic).
    passed = ran and not timeout and (rc == 0 or (not errors and "panicked" not in out and "Error:" in out))
    ok = {unit} if passed else set()
    failed = set() if passed else ({unit} | lines)
    return ok, failed, ran and not timeout, rc, timeout, out


def run_testfile(marker, tree, unit):
    """Sync the candidate's tree into its slot (rebuilding if another
    candidate used the slot since), run the .slt file twice there."""
    t0 = time.time()
    bdir = Path(marker).parent
    real = (bdir / "tree").resolve() if (bdir / "tree").exists() else Path(tree).resolve()
    pref = int((bdir / "slot").read_text()) if (bdir / "slot").exists() else None
    with _Slot(pref) as slot:
        exe, log = _sync_build(slot, real)
        if not exe:
            return {"ok": [], "ok_all": [], "failed": [unit], "complete": False, "rc": None,
                    "timeout": False, "seconds": round(time.time() - t0, 1), "tail": "build: " + log[-1200:]}
        a = _run_once(exe, slot.dir / "src", unit)
        b = _run_once(exe, slot.dir / "src", unit)
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
    """The oracle files are the fix's own .slt files (only test files the fix
    touched are units), so every failing case is the fix's."""
    return {u: names for u, names in failing.items() if names}
