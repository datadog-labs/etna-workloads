#!/usr/bin/env python3
"""Run a reproducer with a given rustc and classify the output against the recorded
expected outputs (same normalisation as the harness that recorded them).
usage: run_repro.py REPRO_DIR RUSTC   -> prints BUG PRESENT / CLEAN / UNKNOWN"""
import os
import re
import resource
import shutil
import signal
import subprocess
import sys
import tempfile


def normalise(text, run_dir, rustc):
    sysroot = os.path.dirname(os.path.dirname(rustc))
    for a, b in ((run_dir, "<RUN>"), (sysroot, "<SYSROOT>"), (os.path.dirname(sysroot), "<BUILD>")):
        text = text.replace(a, b)
    text = re.sub(r"/home/[^\s:'\"]*", "<PATH>", text)
    text = re.sub(r"/tmp/[^\s:'\"]*", "<TMP>", text)
    text = re.sub(r"thread '([^']*)' \(\d+\)", r"thread '\1' (<TID>)", text)
    text = re.sub(r"0x[0-9a-f]{6,}", "<ADDR>", text)
    return text


def run(src, rustc):
    d = tempfile.mkdtemp()
    try:
        wd = os.path.join(d, "r")
        shutil.copytree(src, wd, ignore=shutil.ignore_patterns("expected_*.txt"))
        env = {"PATH": "/usr/bin:/bin", "RUSTC": rustc, "TMPDIR": d, "HOME": d,
               "LANG": "C.UTF-8", "RUST_BACKTRACE": "0", "RUSTC_ICE": "0"}
        # Own process group, killed as a whole on timeout (a plain timeout kills only bash and
        # leaves an injected compiler running), and 6 GiB of address space per process:
        # injected compilers can grow without bound.  Same rules as the recording harness.
        p = subprocess.Popen(["bash", "repro.sh"], cwd=wd, env=env, stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT, start_new_session=True,
                             preexec_fn=lambda: resource.setrlimit(resource.RLIMIT_AS, (6 << 30, 6 << 30)))
        try:
            o, _ = p.communicate(timeout=120)
            out, code = o.decode(errors="replace"), p.returncode
        except subprocess.TimeoutExpired:
            out, code = "<TIMEOUT>", "timeout"
        finally:
            try:
                os.killpg(p.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            p.communicate()
        return normalise(out, wd, rustc) + f"\n[exit {code}]\n"
    finally:
        shutil.rmtree(d, ignore_errors=True)


def main():
    src, rustc = sys.argv[1], os.path.abspath(sys.argv[2])
    got = run(src, rustc)
    clean = open(os.path.join(src, "expected_clean.txt")).read()
    inj = open(os.path.join(src, "expected_injected.txt")).read()
    if got == inj:
        print("BUG PRESENT")
        sys.exit(1)
    if got == clean:
        print("CLEAN")
        sys.exit(0)
    print("UNKNOWN (output matches neither recorded output)")
    sys.exit(2)


if __name__ == "__main__":
    main()
