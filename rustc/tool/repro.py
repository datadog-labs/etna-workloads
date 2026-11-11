#!/usr/bin/env python3
"""Reproducer harness.

A reproducer is a directory with `repro.sh` (plus any single-file inputs it
uses).  The script compiles/runs inputs with "$RUSTC" and prints what it
observes.  The harness runs it in a private copy of the directory:
twice with the clean compiler (must be identical = deterministic) and twice
with the injected compiler; the bug is reproduced iff the normalised
(output, exit status) of the injected runs differs from the clean one (and
the injected runs agree with each other).

usage: repro.py CHECK_DIR CLEAN_RUSTC INJECTED_RUSTC   -> prints JSON verdict
"""
import json
import os
import re
import resource
import shutil
import signal
import subprocess
import sys
import tempfile

sys.path.insert(0, os.path.dirname(__file__))
from common import WORK  # noqa: E402

RUNS = os.environ.get("REPRO_RUNS", os.path.join(WORK, "repro-runs"))
FORBIDDEN = re.compile(r"(--version|\s-V\b|-vV\b|--print\s*=?\s*sysroot|\bgit\b|\bcargo\b|rustc-etna|/home/)")
TIMEOUT = 120
MEM_LIMIT = 6 << 30  # same per-process limit as compiletest runs (runner.TEST_MEM_LIMIT)


def _limit_mem():
    resource.setrlimit(resource.RLIMIT_AS, (MEM_LIMIT, MEM_LIMIT))


def normalise(text, run_dir, rustc):
    sysroot = os.path.dirname(os.path.dirname(rustc))
    for a, b in ((run_dir, "<RUN>"), (sysroot, "<SYSROOT>"), (os.path.dirname(sysroot), "<BUILD>")):
        text = text.replace(a, b)
    text = re.sub(r"/home/[^\s:'\"]*", "<PATH>", text)
    text = re.sub(r"/tmp/[^\s:'\"]*", "<TMP>", text)
    text = re.sub(r"thread '([^']*)' \(\d+\)", r"thread '\1' (<TID>)", text)
    text = re.sub(r"0x[0-9a-f]{6,}", "<ADDR>", text)
    return text


def run_once(src, rustc):
    os.makedirs(RUNS, exist_ok=True)
    d = tempfile.mkdtemp(dir=RUNS)
    try:
        wd = os.path.join(d, "r")
        shutil.copytree(src, wd)
        env = {"PATH": "/usr/bin:/bin", "RUSTC": rustc, "TMPDIR": d, "HOME": d,
               "LANG": "C.UTF-8", "RUST_BACKTRACE": "0", "RUSTC_ICE": "0"}
        # Own process group, killed as a whole on timeout (a bare timeout kills only
        # bash and leaves the compiler running), and an address-space limit per process:
        # injected compilers can grow without bound.
        p = subprocess.Popen(["bash", "repro.sh"], cwd=wd, env=env, stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT, start_new_session=True, preexec_fn=_limit_mem)
        try:
            o, _ = p.communicate(timeout=TIMEOUT)
            out = o.decode(errors="replace")
            code = p.returncode
        except subprocess.TimeoutExpired:
            out, code = "<TIMEOUT>", "timeout"
        finally:
            try:
                os.killpg(p.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            p.communicate()
        return dict(out=normalise(out, wd, rustc), exit=code)
    finally:
        shutil.rmtree(d, ignore_errors=True)


SETUP_ERROR = re.compile(r"can't find crate for `(std|core|alloc|proc_macro|test)`|E0463|error while loading shared libraries")


def health(rustc):
    """The compiler must build and run a hello-world with its own sysroot."""
    d = tempfile.mkdtemp(dir=RUNS) if os.path.isdir(RUNS) else (os.makedirs(RUNS, exist_ok=True) or tempfile.mkdtemp(dir=RUNS))
    try:
        open(os.path.join(d, "h.rs"), "w").write('fn main() { println!("ok"); }\n')
        r = subprocess.run([rustc, "h.rs", "-o", "h"], cwd=d, capture_output=True, text=True, timeout=120)
        if r.returncode:
            return dict(ok=False, why="hello world does not compile", out=r.stderr[-1500:])
        r = subprocess.run(["./h"], cwd=d, capture_output=True, text=True, timeout=60)
        return dict(ok=r.stdout.strip() == "ok", why="hello world output " + r.stdout.strip()[:50])
    finally:
        shutil.rmtree(d, ignore_errors=True)


def check(src, clean, injected):
    script = os.path.join(src, "repro.sh")
    if not os.path.exists(script):
        return dict(ok=False, why="no repro.sh")
    body = open(script).read()
    m = FORBIDDEN.search(body)
    if m:
        return dict(ok=False, why=f"forbidden construct in repro.sh: {m.group(0)!r}")
    for name, rc in (("clean", clean), ("injected", injected)):
        hc = health(rc)
        if not hc["ok"]:
            return dict(ok=False, why=f"{name} compiler unhealthy: {hc['why']}", health=hc)
    c1, c2 = run_once(src, clean), run_once(src, clean)
    if c1 != c2:
        return dict(ok=False, why="clean output not deterministic", clean=[c1, c2])
    i1, i2 = run_once(src, injected), run_once(src, injected)
    v = dict(clean=c1, injected=i1, injected_stable=(i1 == i2))
    if SETUP_ERROR.search(c1["out"]) or SETUP_ERROR.search(i1["out"]):
        v.update(ok=False, why="setup error in output (missing crate/sysroot)")
    elif i1 == c1 or i2 == c1:
        v.update(ok=False, why="no difference between clean and injected")
    elif i1 != i2:
        v.update(ok=False, why="injected output not deterministic")
    else:
        v.update(ok=True, why="differs")
    return v


if __name__ == "__main__":
    print(json.dumps(check(*sys.argv[1:4]), indent=1))
