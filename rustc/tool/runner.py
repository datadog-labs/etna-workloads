"""Build and compiletest runner for a build slot, with an output parser."""
import contextlib
import fcntl
import os
import re
import resource
import signal
import subprocess
import time

import memguard
from common import InfraError

ANSI = re.compile(r"\x1b\[[0-9;?]*[A-Za-z]")
# test [ui] tests/ui/foo/bar.rs#rev ... ok
TEST_LINE = re.compile(r"^test \[([\w-]+)\] (\S+?)(?:#(\S+))? \.\.\. (ok|FAILED|ignored|timeout)\b(.*)$")
SUMMARY = re.compile(r"^test result: (\w+)\. (\d+) passed; (\d+) failed; (\d+) ignored")

X_TEST = ["./x", "test", "--stage", "1", "--keep-stage-std", "1", "--force-rerun", "--no-fail-fast"]


def parse(text):
    """Return ({case_id: outcome}, [summaries]).  case_id = 'path' or 'path#rev'.

    outcome is one of ok / failed / ignored / timeout.  If a case is reported
    twice (substring filters can select a file twice), a failure wins.
    """
    cases, sums = {}, []
    for raw in text.splitlines():
        line = ANSI.sub("", raw).rstrip()
        m = TEST_LINE.match(line)
        if m:
            _suite, path, rev, out, _rest = m.groups()
            cid = f"{path}#{rev}" if rev else path
            out = {"FAILED": "failed"}.get(out, out)
            if cases.get(cid) != "failed":
                cases[cid] = out
            continue
        m = SUMMARY.match(line)
        if m:
            sums.append(dict(result=m.group(1), passed=int(m.group(2)),
                             failed=int(m.group(3)), ignored=int(m.group(4))))
    return cases, sums


def case_file(cid):
    return cid.split("#", 1)[0]


TEST_MEM_LIMIT = 6 << 30    # bytes of address space per process in test runs
BUILD_MEM_LIMIT = 16 << 30  # per process in builds (rustc/cc/ld): a runaway one dies, not the host


def _limiter(limit):
    def f():
        resource.setrlimit(resource.RLIMIT_AS, (limit, limit))
    return f


def run(cmd, cwd, log, timeout, env=None, mem_limit=None, kind=None):
    """Run in a new process group; on timeout kill the whole group (./x ->
    bootstrap -> compiletest -> rustc), so hung injected compilers don't survive.
    kind (build/anchor_build/test/llvm): reserve that much memory first (memguard)
    and register the group with the watchdog; a run the watchdog kills is re-run
    (after memory is back), never returned as a result.
    mem_limit: True = TEST_MEM_LIMIT, or a byte count; builds get BUILD_MEM_LIMIT."""
    if mem_limit is True:
        mem_limit = TEST_MEM_LIMIT
    if mem_limit is None and kind in ("build", "anchor_build", "llvm"):
        mem_limit = BUILD_MEM_LIMIT
    permit = memguard.permit(kind) if kind else contextlib.nullcontext()
    with permit:
        for attempt in range(memguard.MAX_KILLS + 1):
            t = time.time()
            with open(log, "wb") as f:
                p = subprocess.Popen(cmd, cwd=cwd, stdout=f, stderr=subprocess.STDOUT, env=env,
                                     start_new_session=True,
                                     preexec_fn=_limiter(mem_limit) if mem_limit else None)
                if kind:
                    memguard.register(p.pid, kind, cmd)
                try:
                    code = p.wait(timeout=timeout)
                except subprocess.TimeoutExpired:
                    code = "timeout"
                finally:
                    try:
                        os.killpg(p.pid, signal.SIGKILL)  # stragglers too
                    except ProcessLookupError:
                        pass
                    p.wait()
            killed = memguard.unregister(p.pid) if kind else False
            if not killed:
                return code, time.time() - t
            print(f"memory watchdog killed {kind} job in {cwd} (attempt {attempt + 1})", flush=True)
            if attempt < memguard.MAX_KILLS:
                memguard.wait_for_memory(memguard.GB[kind], kind)
    raise InfraError(f"{kind} job in {cwd} killed by the memory watchdog {memguard.MAX_KILLS + 1} times")


LOCKS = os.path.join(os.path.expanduser("~"), "rustc-etna-work", "locks")
MAX_BUILDS = 4


MIN_FREE = 40 << 30  # bytes; builds wait below this (the disk once filled up: ENOSPC)


def free_bytes(path=LOCKS):
    st = os.statvfs(os.path.dirname(path))
    return st.f_bavail * st.f_frsize


def wait_for_disk():
    warned = False
    while free_bytes() < MIN_FREE:
        if not warned:
            print(f"low disk: {free_bytes() >> 30} GiB free, waiting before build", flush=True)
            warned = True
        time.sleep(60)


@contextlib.contextmanager
def build_permit(pool="build", n=None):
    """At most n concurrent builds per pool across all processes (memory/CPU).
    Anchors (full builds of old commits) use their own small pool so they do not
    starve the incremental gate builds."""
    n = n or MAX_BUILDS
    os.makedirs(LOCKS, exist_ok=True)
    wait_for_disk()
    while True:
        for i in range(n):
            f = open(os.path.join(LOCKS, f"{pool}{i}"), "w")
            try:
                fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError:
                f.close()
                continue
            try:
                yield
            finally:
                fcntl.flock(f, fcntl.LOCK_UN)
                f.close()
            return
        time.sleep(5)


def build(slot, log, timeout=3600):
    """Incremental stage-1 compiler build keeping the slot's std."""
    with build_permit():
        return run(["./x", "build", "--stage", "1", "--keep-stage-std", "1", "compiler/rustc"],
                   slot, log, timeout, kind="build")


def populate_sysroot(slot, log, timeout=3600):
    """`x build compiler/rustc` leaves the stage-1 sysroot without std; `x test`
    re-copies it, but a bare compiler used directly (reproducers) needs this."""
    with build_permit():
        return run(["./x", "build", "--stage", "1", "--keep-stage-std", "1", "library"], slot, log, timeout,
                   kind="build")


def build_library(slot, log, timeout=3600):
    with build_permit():
        return run(["./x", "build", "--stage", "1", "library"], slot, log, timeout, kind="build")


def test(slot, paths, log, timeout=1200, xcmd=None, env=None):
    """Run compiletest on the given case files; returns (exit, secs, cases, sums)."""
    paths = sorted({p for p in paths if os.path.exists(os.path.join(slot, p))})
    if not paths:
        return None, 0.0, {}, []
    cmd = (xcmd + X_TEST[1:]) if xcmd else X_TEST
    # Injected compilers can grow without bound (one reached 41 GB in 6 min); an
    # address-space limit per process stops that.  Base cases were re-validated under it.
    code, secs = run(cmd + paths, slot, log, timeout, env=env, mem_limit=True, kind="test")
    with open(log, errors="replace") as f:
        cases, sums = parse(f.read())
    return code, secs, cases, sums


def failure_excerpts(text, cids, limit=2500):
    """The '---- [suite] path stdout ----' block for each failing case id."""
    text = ANSI.sub("", text)
    out = {}
    for cid in cids:
        start = text.find(f"] {cid} stdout ----")
        if start < 0:
            continue
        end = text.find(f"] {cid} stdout end ----", start)
        block = text[start:end if end > 0 else start + limit]
        out[cid] = block[:limit]
    return out
