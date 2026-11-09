"""Run a command in its own process group with a wall-clock timeout and an
RSS watchdog. The watched set is the process group plus every descendant
(sandbox wrappers may start children in a new session). On either limit,
the whole set is killed."""
import os, signal, subprocess, time

PAGE = os.sysconf("SC_PAGE_SIZE")


def _procs():
    out = {}
    for pid in os.listdir("/proc"):
        if not pid.isdigit():
            continue
        try:
            with open(f"/proc/{pid}/stat") as f:
                fields = f.read().rsplit(")", 1)[1].split()
            with open(f"/proc/{pid}/statm") as f:
                rss = int(f.read().split()[1]) * PAGE
            out[int(pid)] = (int(fields[1]), int(fields[2]), rss)  # ppid, pgrp, rss
        except (OSError, IndexError, ValueError):
            pass
    return out


def _watched(root):
    ps = _procs()
    kids = {}
    for pid, (ppid, _, _) in ps.items():
        kids.setdefault(ppid, []).append(pid)
    seen, stack = set(), [root]
    while stack:
        p = stack.pop()
        if p in seen:
            continue
        seen.add(p)
        stack += kids.get(p, [])
    seen |= {pid for pid, (_, pg, _) in ps.items() if pg == root}
    return seen, sum(ps[p][2] for p in seen if p in ps)


def _kill(root):
    pids, _ = _watched(root)
    try:
        os.killpg(root, signal.SIGKILL)
    except ProcessLookupError:
        pass
    for p in pids:
        try:
            os.kill(p, signal.SIGKILL)
        except ProcessLookupError:
            pass


def run(cmd, cwd, log_path, timeout=1800, rss_mb=8192, env=None, stdout_path=None):
    """Returns (returncode, reason) where reason is None, 'timeout' or 'rss'.
    stdout goes to stdout_path if given (stderr to log_path), else both to log_path."""
    with open(log_path, "ab") as log:
        out = open(stdout_path, "wb") if stdout_path else log
        p = subprocess.Popen(cmd, cwd=cwd, stdout=out, stderr=log if stdout_path else subprocess.STDOUT,
                             stdin=subprocess.DEVNULL, start_new_session=True, env=env)
        deadline = time.monotonic() + timeout
        reason = None
        n = 0
        while True:
            try:
                rc = p.wait(timeout=0.5)
                break
            except subprocess.TimeoutExpired:
                pass
            n += 1
            if time.monotonic() > deadline:
                reason = "timeout"
            elif n % 2 == 0 and _watched(p.pid)[1] > rss_mb * 2**20:
                reason = "rss"
            if reason:
                _kill(p.pid)
                rc = p.wait()
                break
        # Reap anything left in the group (e.g. orphaned grandchildren).
        try:
            os.killpg(p.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
        if stdout_path:
            out.close()
        if reason:
            log.write(f"\n[proc] killed: {reason}\n".encode())
        return rc, reason
