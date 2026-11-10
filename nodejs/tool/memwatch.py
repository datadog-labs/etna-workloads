#!/usr/bin/env python3
"""Memory watchdog for every Node.js binary built under the work tree.

No cgroups are available without root on this host, and RLIMIT_AS (ulimit -v) cannot be
used: V8 reserves tens of GB of virtual address space (pointer-compression cage, wasm
guard regions) in normal operation, so a virtual-memory cap changes test results.
This daemon enforces an RSS cap instead:
  - any process whose executable is <work>/.../out/Release/{node,cctest} (slots, base,
    anchor trees) is SIGKILLed when its RSS exceeds --max-rss-gb;
  - if host MemAvailable drops below --min-avail-gb, the largest such process is killed.
Kills are logged (JSON lines).  Harness entry points call require() and refuse to run
unless the watchdog is alive.
"""
import argparse, json, os, signal, sys, time

W = os.path.realpath(os.path.expanduser("~/node-etna-work"))
PIDFILE = os.path.join(W, "memwatch.pid")
LOG = os.path.join(W, "logs", "memwatch.log")
WATCH_SUFFIXES = ("/out/Release/node", "/out/Release/cctest")


def watched():
    for pid in os.listdir("/proc"):
        if not pid.isdigit():
            continue
        try:
            exe = os.readlink(f"/proc/{pid}/exe").replace(" (deleted)", "")
        except OSError:
            continue
        if exe.startswith(W + "/") and exe.endswith(WATCH_SUFFIXES):
            try:
                with open(f"/proc/{pid}/status") as f:
                    rss = next(int(l.split()[1]) for l in f if l.startswith("VmRSS:"))
            except (OSError, StopIteration):
                continue
            yield int(pid), exe, rss * 1024


def mem_available():
    with open("/proc/meminfo") as f:
        for l in f:
            if l.startswith("MemAvailable:"):
                return int(l.split()[1]) * 1024


def kill(pid, exe, rss, why):
    try:
        cmd = open(f"/proc/{pid}/cmdline", "rb").read().replace(b"\0", b" ")[:300].decode(errors="replace")
        cwd = os.readlink(f"/proc/{pid}/cwd")
    except OSError:
        cmd, cwd = "?", "?"
    try:
        os.kill(pid, signal.SIGKILL)
    except OSError:
        return
    with open(LOG, "a") as f:
        f.write(json.dumps({"t": time.time(), "pid": pid, "exe": exe, "cwd": cwd, "rss_gb": round(rss / 2**30, 2),
                            "why": why, "cmd": cmd}) + "\n")


def require():
    """Raise unless the watchdog daemon is running."""
    try:
        pid = int(open(PIDFILE).read())
        os.kill(pid, 0)
        if b"memwatch.py" not in open(f"/proc/{pid}/cmdline", "rb").read():
            raise OSError
    except (OSError, ValueError):
        raise SystemExit("memwatch.py is not running; start it first (tools/memwatch.py --daemon)")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--max-rss-gb", type=float, default=8.0)
    ap.add_argument("--min-avail-gb", type=float, default=10.0)
    ap.add_argument("--interval", type=float, default=0.5)
    a = ap.parse_args()
    open(PIDFILE, "w").write(str(os.getpid()))
    cap = a.max_rss_gb * 2**30
    floor = a.min_avail_gb * 2**30
    while True:
        procs = list(watched())
        for pid, exe, rss in procs:
            if rss > cap:
                kill(pid, exe, rss, f"rss>{a.max_rss_gb}GB")
        if mem_available() < floor and procs:
            pid, exe, rss = max(procs, key=lambda p: p[2])
            kill(pid, exe, rss, f"MemAvailable<{a.min_avail_gb}GB")
        time.sleep(a.interval)


if __name__ == "__main__":
    main()
