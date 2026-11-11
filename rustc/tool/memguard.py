"""Host memory protection (the host once wedged for ~3 h: 8 concurrent bootstraps +
compiletest runs + agents exhausted 62 GB RAM and the 128 GB swap turned that into
thrashing instead of OOM kills; DNS and SSH stopped answering).

Three layers:
  * permit(gb): every heavy job (build, test run, LLVM build, agent) reserves an
    estimated amount of memory from a fixed budget, held as flock'd unit files, so a
    crashed holder releases automatically.  A job also waits until MemAvailable
    covers its estimate plus a reserve, and until the watchdog is alive.
  * jobs register their process group (runner.run) so the watchdog (memwatch.py)
    can kill the largest one when memory runs low or swap starts growing.
  * a killed job is never a result: runner.run sees the watchdog's marker, waits for
    memory and re-runs it; after MAX_KILLS it raises InfraError.
"""
import contextlib
import fcntl
import json
import os
import time

LOCKS = os.path.join(os.path.expanduser("~"), "rustc-etna-work", "locks")
UNITS = os.path.join(LOCKS, "mem")
JOBS = os.path.join(LOCKS, "jobs")
KILLED = os.path.join(LOCKS, "killed")
HEARTBEAT = os.path.join(LOCKS, "memwatch.heartbeat")

UNIT_GB = 2
BUDGET_GB = 44        # of 62 GB RAM; the rest is OS, page cache, the watchdog's margin
RESERVE_GB = 8        # MemAvailable that must remain after a new job's estimate
MAX_KILLS = 3

# Estimated peak memory per job kind (GB).  memwatch logs measured per-job RSS to tune these.
GB = dict(build=8, anchor_build=12, test=8, llvm=16, agent=2)


def meminfo():
    m = {}
    with open("/proc/meminfo") as f:
        for line in f:
            k, v = line.split(":", 1)
            m[k] = int(v.split()[0]) * 1024
    return m


def avail_gb():
    return meminfo()["MemAvailable"] / (1 << 30)


def swap_used_gb():
    m = meminfo()
    return (m["SwapTotal"] - m["SwapFree"]) / (1 << 30)


def watchdog_alive(max_age=60):
    try:
        return time.time() - os.path.getmtime(HEARTBEAT) < max_age
    except OSError:
        return False


def wait_for_memory(gb, what=""):
    warned = False
    while not watchdog_alive() or avail_gb() < gb + RESERVE_GB:
        if not warned:
            why = "watchdog not running" if not watchdog_alive() else f"{avail_gb():.0f} GiB available"
            print(f"memory guard: waiting before {what or 'job'} ({why}, need {gb}+{RESERVE_GB})", flush=True)
            warned = True
        time.sleep(15)


@contextlib.contextmanager
def permit(kind, gb=None):
    """Reserve gb (default: the kind's estimate) from the budget for the duration."""
    gb = gb or GB[kind]
    need = max(1, -(-gb // UNIT_GB))
    os.makedirs(UNITS, exist_ok=True)
    held = []
    try:
        while True:
            wait_for_memory(gb, kind)
            for i in range(BUDGET_GB // UNIT_GB):
                f = open(os.path.join(UNITS, f"u{i}"), "w")
                try:
                    fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
                except BlockingIOError:
                    f.close()
                    continue
                held.append(f)
                if len(held) == need:
                    break
            if len(held) == need:
                break
            for f in held:  # all-or-nothing, so partial holders cannot deadlock
                fcntl.flock(f, fcntl.LOCK_UN)
                f.close()
            held = []
            time.sleep(5 + (os.getpid() % 7))
        yield
    finally:
        for f in held:
            fcntl.flock(f, fcntl.LOCK_UN)
            f.close()


def register(pgid, kind, cmd):
    os.makedirs(JOBS, exist_ok=True)
    with open(os.path.join(JOBS, str(pgid)), "w") as f:
        json.dump(dict(kind=kind, start=time.time(), owner=os.getpid(), cmd=" ".join(map(str, cmd))[:300]), f)


def unregister(pgid):
    """Returns True if the watchdog killed this job."""
    for d in (JOBS,):
        try:
            os.unlink(os.path.join(d, str(pgid)))
        except FileNotFoundError:
            pass
    m = os.path.join(KILLED, str(pgid))
    if os.path.exists(m):
        os.unlink(m)
        return True
    return False
