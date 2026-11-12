#!/usr/bin/env python3
"""Run a command in its own process group under a wall-clock timeout and an RSS cap.

usage: guard.py --timeout SEC --rss-mb MB [--log FILE] -- cmd args...
The RSS cap is enforced by a watchdog (sum of RSS of every process in the group,
polled every 0.5 s) because ASan builds cannot run under RLIMIT_AS.
On timeout or cap breach the whole group gets SIGTERM, then SIGKILL after 5 s.
Exit status: the command's, or 124 (timeout) / 125 (rss cap) / 126 (spawn failure).
A one-line JSON verdict is written to stderr prefixed with 'GUARD '.
"""
import argparse, json, os, signal, subprocess, sys, time

ap = argparse.ArgumentParser()
ap.add_argument("--timeout", type=float, required=True)
ap.add_argument("--rss-mb", type=int, required=True)
ap.add_argument("--log")
ap.add_argument("--cwd")
ap.add_argument("cmd", nargs=argparse.REMAINDER)
a = ap.parse_args()
cmd = a.cmd[1:] if a.cmd and a.cmd[0] == "--" else a.cmd
PAGE = os.sysconf("SC_PAGE_SIZE")


def session_pids(sid):
    """All live processes in session `sid` (ninja moves jobs into their own process
    groups, so the session, not the process group, is what contains every child)."""
    pids = []
    for p in os.listdir("/proc"):
        if not p.isdigit():
            continue
        try:
            with open(f"/proc/{p}/stat") as f:
                s = f.read()
            fields = s[s.rindex(")") + 2:].split()
            if int(fields[3]) == sid and fields[0] != "Z":  # field 6 = session
                pids.append((int(p), int(fields[21]) * PAGE))
        except (OSError, ValueError, IndexError):
            pass
    return pids


def group_rss(sid):
    return sum(r for _, r in session_pids(sid))


def kill_group(sid, proc=None):
    """SIGTERM then SIGKILL every process of the session (and its process groups)."""
    for sig in (signal.SIGTERM, signal.SIGKILL):
        pids = session_pids(sid)
        if not pids:
            return
        for pid, _ in pids:
            for f in (os.kill, lambda p, s: os.killpg(os.getpgid(p), s)):
                try:
                    f(pid, sig)
                except (ProcessLookupError, PermissionError):
                    pass
        for _ in range(50):
            if proc is not None:
                proc.poll()  # reap the leader so a zombie does not keep the session alive
            if not session_pids(sid):
                return
            time.sleep(0.1)

out = open(a.log, "ab") if a.log else None
t0 = time.time()
try:
    p = subprocess.Popen(cmd, cwd=a.cwd, stdout=out or None, stderr=subprocess.STDOUT if out else None,
                         start_new_session=True)
except OSError as e:
    print("GUARD " + json.dumps({"status": "spawn-failed", "error": str(e)}), file=sys.stderr)
    sys.exit(126)
verdict, peak = "exit", 0


def _on_term(signum, frame):
    # forward termination to the supervised session so nothing outlives the guard
    kill_group(p.pid, p)
    sys.exit(128 + signum)


signal.signal(signal.SIGTERM, _on_term)
signal.signal(signal.SIGINT, _on_term)
while True:
    try:
        rc = p.wait(timeout=0.5)
        break
    except subprocess.TimeoutExpired:
        pass
    r = group_rss(p.pid)
    peak = max(peak, r)
    if time.time() - t0 > a.timeout:
        verdict = "timeout"
    elif r > a.rss_mb * 1024 * 1024:
        verdict = "rss-cap"
    if verdict != "exit":
        kill_group(p.pid, p)
        p.wait()
        rc = 124 if verdict == "timeout" else 125
        break
# reap stragglers that outlived the leader
kill_group(p.pid, p)
print("GUARD " + json.dumps({"status": verdict, "rc": rc, "secs": round(time.time() - t0, 1),
                             "peak_rss_mb": peak // 2**20}), file=sys.stderr)
sys.exit(rc)
