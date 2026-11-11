"""RSS watchdog for the dataset pipeline (replaces RLIMIT_AS).
Every 10 s: kill any process whose cwd is under ~/ocaml-etna-work and whose RSS exceeds
16 GB; if MemAvailable < 4 GB, kill the largest such process.  Logs to logs/watchdog.log."""
import os, signal, time
from pathlib import Path
WORK = str(Path.home() / "ocaml-etna-work")
LOG = Path(WORK) / "logs" / "watchdog.log"
RSS_MAX = 16 << 20       # kB
AVAIL_MIN = 4 << 20      # kB


def procs():
    for p in os.listdir("/proc"):
        if not p.isdigit():
            continue
        try:
            cwd = os.readlink(f"/proc/{p}/cwd")
            if not cwd.startswith(WORK):
                continue
            rss = 0
            for l in open(f"/proc/{p}/status"):
                if l.startswith("VmRSS:"):
                    rss = int(l.split()[1])
            cmd = open(f"/proc/{p}/cmdline", "rb").read().replace(b"\0", b" ")[:150].decode(errors="replace")
            yield int(p), rss, cwd, cmd
        except (OSError, ValueError):
            continue


def kill(pid, rss, cwd, cmd, why):
    try:
        os.kill(pid, signal.SIGKILL)
        with open(LOG, "a") as f:
            f.write(f"{time.ctime()} killed {pid} rss={rss >> 20}GB ({why}) cwd={cwd} cmd={cmd}\n")
    except OSError:
        pass


while True:
    ps = list(procs())
    for pid, rss, cwd, cmd in ps:
        if rss > RSS_MAX:
            kill(pid, rss, cwd, cmd, "rss>16GB")
    avail = int(next(l for l in open("/proc/meminfo") if l.startswith("MemAvailable")).split()[1])
    if avail < AVAIL_MIN and ps:
        kill(*max(ps, key=lambda t: t[1]), why=f"MemAvailable={avail >> 20}GB")
    time.sleep(10)
