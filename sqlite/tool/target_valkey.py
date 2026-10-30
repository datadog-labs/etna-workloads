"""Valkey target for the etna pipeline (ETNA_KIND=valkey).

Imported at the end of sqlite_etna.py; every name defined here replaces the
SQLite one in that module, so the shared stages (gate, base, verbatim,
adapt, anchor) use Valkey's build and test runner.

  build    make MALLOC=libc in a copy of the tree; the "testfixture" path is
           the built src/valkey-server (src/redis-server before the rename)
  tests    ./runtest --single <unit> --clients 1 with a private port range
           (several runs share the machine); each file runs twice, and a
           case counts as passing when it passed in either run ("ok") and as
           a stable pass when it passed in both ("ok_all")
  oracle   the cases of the fix's test files that passed both base runs;
           an injection must make a case fail in both of its runs
  mining   also merge commits on the first-parent line: older Redis fixes
           often put the code and the test in separate commits of one PR
"""

import fcntl
import os
import re
import shutil
import subprocess
import time
from pathlib import Path

NAME = "Valkey"
IMPL_DESC = "src/ (not deps/, src/unit/ or src/modules/)"
IMPL = re.compile(r"^src/.*\.(c|h)$")
NOT_IMPL = re.compile(r"(^src/modules/|^src/unit/|^src/.*test.*\.(c|h)$|^deps/|^src/commands/)")
TESTFILE = re.compile(r"^tests/(unit|integration)/(?!moduleapi/).*\.tcl$")
FIXWORD = re.compile(r"\bfix|\bbugs?\b|crash|assert|incorrect|wrong|segfault|overflow|corrupt|leak|"
                     r"race|deadlock|hang|problem|error|issue|invalid|regression|uninitiali", re.I)
# test {name} ... / test "name" ...
TESTCASE = re.compile(r"^\+\s*test\s+(?:\{([^}]*)\}|\"([^\"]*)\")")
REPORT = re.compile(r"(#\d{2,6})")
MINE_MERGES = True

ANSI = re.compile(r"\x1b\[[0-9;]*m")
OKLINE = re.compile(r"^\[ok\]: (.*) \(\d+ ms\)\s*$")
ERRLINE = re.compile(r"^\[err\]: (.*?)(?: in (?:tests/|\./tests/).*)?$")
PORTS_BASE, PORTS_SPAN, PORT_SLOTS = 21000, 400, 96


def _E():
    import sqlite_etna as E
    return E


def testcase_name(m):
    return m.group(1) if m.group(1) is not None else m.group(2)


def base_paths():
    E = _E()
    return E.WORK / "base-src", E.WORK / "base-build" / "src" / "valkey-server"


def _server_binary(bdir):
    for name in ("valkey-server", "redis-server"):
        if (bdir / "src" / name).exists():
            return bdir / "src" / name
    return None


BUILDS = [
    ["make", "MALLOC=libc", "OPTIMIZATION=-O1", "BUILD_TLS=no"],
    # Old Redis trees: gcc 10+ defaults to -fno-common, and newer warnings.
    ["make", "MALLOC=libc", "OPTIMIZATION=-O1", "CFLAGS=-fcommon -Wno-error", "BUILD_TLS=no"],
    ["make", "MALLOC=libc", "CFLAGS=-fcommon -Wno-error -std=gnu99"],
]


def build_testfixture(src_tree, bdir, jobs=2):
    """Build the server tree in a fresh copy; returns (server path, secs, log)."""
    E = _E()
    t0 = time.time()
    if bdir.exists():
        shutil.rmtree(bdir)
    shutil.copytree(src_tree, bdir, symlinks=True)
    env = {**os.environ, "CC": "ccache gcc", "CCACHE_BASEDIR": str(bdir),
           "CCACHE_DIR": os.environ.get("CCACHE_DIR", str(E.WORK / "ccache"))}
    log = ""
    for i, cmd in enumerate(BUILDS):
        if i:
            E.run(["make", "distclean"], cwd=bdir, check=False, env=env)
        r = E.run([*cmd, f"-j{jobs}"], cwd=bdir, check=False, env=env, timeout=3600)
        if r.returncode == 0 and _server_binary(bdir):
            return _server_binary(bdir), time.time() - t0, ""
        log = r.stdout[-3000:] + r.stderr[-3000:]
    return None, time.time() - t0, log


class _PortSlot:
    """A private port range, locked across processes (agents run check.sh
    in their own processes)."""

    def __enter__(self):
        E = _E()
        d = E.WORK / "ports"
        d.mkdir(parents=True, exist_ok=True)
        while True:
            for slot in range(PORT_SLOTS):
                f = open(d / f"{slot}.lock", "w")
                try:
                    fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
                except BlockingIOError:
                    f.close()
                    continue
                self.f, self.base = f, PORTS_BASE + slot * PORTS_SPAN
                return self
            time.sleep(2)

    def __exit__(self, *exc):
        fcntl.flock(self.f, fcntl.LOCK_UN)
        self.f.close()


def _rundir(root):
    """A private view of the built tree: runtest cleans ./tests/tmp at start,
    so concurrent runs in one tree would delete each other's servers. The
    top-level entries are symlinks; tests/ is a copy with an empty tmp/."""
    import tempfile
    E = _E()
    (E.WORK / "runs").mkdir(parents=True, exist_ok=True)
    d = Path(tempfile.mkdtemp(prefix="run-", dir=E.WORK / "runs"))
    for p in Path(root).iterdir():
        if p.name != "tests":
            (d / p.name).symlink_to(p)
    # tests/ is copied, not linked: runtest normalizes test paths, which
    # would follow a link back into the shared tree.
    shutil.copytree(Path(root) / "tests", d / "tests", symlinks=True,
                    ignore=lambda dirpath, names: ["tmp"] if Path(dirpath) == Path(root) / "tests" else [])
    (d / "tests" / "tmp").mkdir()
    return d


def _run_once(root, unit):
    E = _E()
    rd = _rundir(root)
    try:
        return _run_in(rd, unit)
    finally:
        shutil.rmtree(rd, ignore_errors=True)


def _run_in(root, unit):
    E = _E()
    with _PortSlot() as ps:
        cmd = ["./runtest", "--single", unit, "--clients", "1", "--timeout", "600",
               "--baseport", str(ps.base), "--portcount", str(PORTS_SPAN - 20)]
        # Own process group: on a timeout the spawned servers go with runtest.
        p = subprocess.Popen(cmd, cwd=root, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                             start_new_session=True)
        try:
            raw, _ = p.communicate(timeout=E.TEST_TIMEOUT)
            rc, timeout = p.returncode, False
        except subprocess.TimeoutExpired:
            os.killpg(p.pid, 9)
            raw, _ = p.communicate()
            rc, timeout = None, True
        out = raw.decode("utf-8", "replace")
    out = ANSI.sub("", out)
    ok, failed = set(), set()
    for line in out.splitlines():
        m = OKLINE.match(line)
        if m:
            ok.add(m.group(1))
            continue
        m = ERRLINE.match(line)
        if m:
            failed.add(m.group(1))
    complete = (("All tests passed" in out or "The following tests failed" in out)
                and "[exception]" not in out and not timeout)
    return ok - failed, failed, complete, rc, timeout, out


def run_testfile(server, tree, testfile):
    """Run one test file twice in the tree the server was built in."""
    t0 = time.time()
    root = Path(server).parent.parent
    unit = re.sub(r"^tests/|\.tcl$", "", testfile)
    if not (root / testfile).exists():
        return {"ok": [], "ok_all": [], "failed": [], "complete": False, "rc": None,
                "timeout": False, "seconds": 0, "tail": f"{testfile} missing"}
    a = _run_once(root, unit)
    b = _run_once(root, unit)
    ok_any, ok_all = a[0] | b[0], a[0] & b[0]
    failed = (a[1] | b[1]) - ok_any            # failed both times (or never passed)
    complete = a[2] and b[2]
    tail = "" if complete and not failed else (a[5][-1500:] if a[1] or not a[2] else b[5][-1500:])
    return {"ok": sorted(ok_any), "ok_all": sorted(ok_all), "failed": sorted(failed),
            "complete": complete, "rc": [a[3], b[3]], "timeout": a[4] or b[4],
            "seconds": round(time.time() - t0, 1), "tail": tail}


def oracle_of(c, base_runs):
    """Cases of the fix's test files that passed both base runs."""
    o = {}
    for f in c["test_files"]:
        br = base_runs.get(f)
        if br and br.get("complete") and br.get("ok_all"):
            o[f] = br["ok_all"]
    return o


def _name_regex(template):
    # "LPOS basic usage - $type" matches "LPOS basic usage - quicklist"
    parts = re.split(r"(\$\{?\w+\}?|\[[^\]]*\])", template)
    return re.compile("^" + "".join(".+" if (p.startswith("$") or p.startswith("[")) else re.escape(p)
                                    for p in parts) + "$")


def added_by_fix(c, failing):
    out = {}
    for f, names in failing.items():
        pats = [_name_regex(a) for a in c["added_tests"].get(f, [])]
        hit = [n for n in names if any(p.match(n) for p in pats)]
        if hit:
            out[f] = hit
    return out
