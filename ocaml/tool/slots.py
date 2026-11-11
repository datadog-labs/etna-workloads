"""Build slots and the ocamltest runner.

A slot is a fixed directory WORK/slots/sN/ocaml holding the release source,
configured and built *in place* (so embedded absolute paths stay valid), plus a
read-only snapshot WORK/slots/sN/snap of that built tree.  Resetting a slot is
`rsync -a --delete snap/ ocaml/` (real copies, no hard links), after which an
injection is applied and `make` rebuilds incrementally.
"""
import os, re, shutil, subprocess, time, uuid
from pathlib import Path
from common import *

SLOTS = WORK / "slots"
RELEASE_SRC = WORK / "release-src"
JOBS = int(os.environ.get("ETNA_JOBS", "6"))
TEST_TIMEOUT = 300           # ocamltest -timeout (per test)
WALL_TIMEOUT = 900           # our own wall clock per unit
# As upstream CI (tools/ci/actions/runner.sh) configures for its test runs.
CONFIGURE_FLAGS = ["--enable-ocamltest", "--enable-native-toplevel"]
RESULT_RE = re.compile(r"^ \.\.\. testing '([^']+)'(?: with [^=]*)? => (passed|failed|skipped|unexpected error)(.*)$", re.M)
ANSI = re.compile(r"\x1b\[[0-9;]*[A-Za-z]")


import resource
MEM_LIMIT = 8 << 30          # per process: a buggy compiler must not exhaust the host


def limit_mem(n=MEM_LIMIT):
    """No-op since 2026-11-05: RLIMIT_AS breaks OCaml 5 runtimes, which reserve large virtual
    ranges (and it made tests/parallel/max_domains2.ml fail on the clean release).
    Runaway memory is handled by watchdog.py (RSS-based) instead."""
    return None


def sh(cmd, cwd, log=None, timeout=None, env=None):
    with open(log, "a") if log else open(os.devnull, "w") as f:
        try:
            r = subprocess.run(cmd, cwd=cwd, shell=isinstance(cmd, str), stdout=f,
                               stderr=subprocess.STDOUT, timeout=timeout, env=env,
                               preexec_fn=limit_mem())
            return r.returncode
        except subprocess.TimeoutExpired:
            return -999


class Slot:
    def __init__(self, n):
        self.n = n
        self.root = SLOTS / f"s{n}"
        self.src = self.root / "ocaml"
        self.snap = self.root / "snap"
        self.log = self.root / "log"

    # ---- lifecycle -------------------------------------------------------
    def prepare(self):
        """Configure+build the release in place and snapshot it (once)."""
        if (self.snap / ".etna-built").exists():
            return True
        if self.root.exists():
            subprocess.run(["chmod", "-R", "u+w", str(self.root)])
            shutil.rmtree(self.root)
        self.root.mkdir(parents=True)
        shutil.copytree(RELEASE_SRC, self.src, symlinks=True)
        subprocess.run(["chmod", "-R", "u+w", str(self.src)])
        lg = self.root / "prepare.log"
        if sh(["./configure", *CONFIGURE_FLAGS, f"--prefix={self.root}/inst"], self.src, lg) != 0:
            return False
        if self.build(lg) != "ok":
            return False
        subprocess.run(["rsync", "-a", "--delete", f"{self.src}/", f"{self.snap}/"], check=True)
        (self.snap / ".etna-built").write_text(time.ctime())
        subprocess.run(["chmod", "-R", "a-w", str(self.snap)], check=True)
        return True

    def reset(self):
        subprocess.run(["rsync", "-a", "--delete", "--exclude=/.etna-built",
                        f"{self.snap}/", f"{self.src}/"], check=True)
        subprocess.run(["chmod", "-R", "u+w", str(self.src)], check=True)
        shutil.rmtree(self.root / "runs", ignore_errors=True)

    def build(self, log=None, clean=False):
        """clean=True: `make clean` first.  Incremental builds are NOT trustworthy here
        (e.g. a stdlib change leaves compilerlibs inconsistent), so the gate always
        builds clean, in place (configuration is kept)."""
        log = log or self.log
        if clean and sh(["make", "clean"], self.src, log, timeout=600) != 0:
            return "build-failed"
        if sh(["make", f"-j{JOBS}"], self.src, log, timeout=3600) != 0:
            return "build-failed"
        if sh(["make", f"-j{JOBS}", "ocamltest"], self.src, log, timeout=1800) != 0:
            return "build-failed"
        return "ok"

    # ---- tests -----------------------------------------------------------
    def run_unit(self, unit, tag="r"):
        """Run one ocamltest file (path relative to testsuite/). Returns (status, detail)."""
        ts = self.src / "testsuite"
        if not (ts / unit).exists():
            return "missing", ""
        priv = self.root / "runs" / f"{tag}-{uuid.uuid4().hex[:8]}"
        priv.mkdir(parents=True)
        env = dict(os.environ, SORT="sort", MAKE="make", TERM="dumb", USE_RUNTIME="d",
                   OCAMLRUNPARAM="v=0", OCAMLTESTDIR=str(priv), TMPDIR=str(priv))
        env.pop("OCAMLPARAM", None)
        try:
            r = subprocess.run(["../ocamltest/ocamltest", "-timeout", str(TEST_TIMEOUT), unit],
                               cwd=ts, env=env, capture_output=True, text=True,
                               errors="replace", timeout=WALL_TIMEOUT, preexec_fn=limit_mem())
            out = ANSI.sub("", r.stdout + r.stderr)
        except subprocess.TimeoutExpired as e:
            shutil.rmtree(priv, ignore_errors=True)
            return "timeout", ""
        shutil.rmtree(priv, ignore_errors=True)
        return parse_result(unit, out, r.returncode)

    def run_units(self, units, tag="r", par=3):
        from concurrent.futures import ThreadPoolExecutor
        with ThreadPoolExecutor(par) as ex:
            res = list(ex.map(lambda u: self.run_unit(u, tag), units))
        return {u: r for u, r in zip(units, res)}


def parse_result(unit, out, rc):
    base = os.path.basename(unit)
    # The per-file summary line has no "with ..." part; step lines do.
    hits = [m for m in RESULT_RE.finditer(out) if m.group(1) == base and " with " not in m.group(0).split("=>")[0]]
    steps = [m.group(0).strip() for m in RESULT_RE.finditer(out) if " with " in m.group(0).split("=>")[0]]
    if len(hits) != 1:
        return ("no-result" if not hits else "ambiguous"), out[-2000:]
    st = hits[0].group(2)
    st = {"unexpected error": "error"}.get(st, st)
    return st, ("\n".join(steps)[:1500] + "\n" + out[-1500:]) if st != "passed" else ""
