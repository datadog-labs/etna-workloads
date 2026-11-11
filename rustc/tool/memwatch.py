#!/usr/bin/env python3
"""Memory watchdog for the run (see memguard.py).

Every 5 s: read MemAvailable and the swap-out rate; every 60 s log a line with the
registered jobs' resident memory to chain/mem.log.  When MemAvailable drops below
KILL_AVAIL_GB, or the host swaps out steadily while memory is tight, SIGKILL the
process group of the registered job with the largest RSS and leave a marker so its
runner re-runs it instead of recording a result.  Writes a heartbeat; heavy jobs do
not start without a live watchdog.
"""
import json
import os
import signal
import sys
import time

sys.path.insert(0, os.path.dirname(__file__))
import memguard as mg  # noqa: E402

LOG = os.environ.get("MEMWATCH_LOG", os.path.join(os.path.expanduser("~"), "rustc-etna-work", "chain", "mem.log"))
KILL_AVAIL_GB = float(os.environ.get("MEMWATCH_KILL_AVAIL_GB", 5))  # override only for tests
SWAP_AVAIL_GB = 12            # swap-out only counts as pressure below this much available
SWAP_OUT_MB_S = 20            # sustained over 3 samples
PAGE = os.sysconf("SC_PAGE_SIZE")


def log(msg):
    with open(LOG, "a") as f:
        f.write(time.strftime("%FT%TZ ", time.gmtime()) + msg + "\n")


def pswpout():
    with open("/proc/vmstat") as f:
        for line in f:
            if line.startswith("pswpout "):
                return int(line.split()[1])
    return 0


def rss_by_pgid():
    out = {}
    for p in os.listdir("/proc"):
        if not p.isdigit():
            continue
        try:
            with open(f"/proc/{p}/stat") as f:
                st = f.read()
            fields = st[st.rindex(")") + 2:].split()
            pgrp, rss = int(fields[2]), int(fields[21])
        except (OSError, ValueError, IndexError):
            continue
        out[pgrp] = out.get(pgrp, 0) + rss * PAGE
    return out


def jobs():
    res = {}
    for name in os.listdir(mg.JOBS) if os.path.isdir(mg.JOBS) else []:
        p = os.path.join(mg.JOBS, name)
        try:
            j = json.load(open(p))
        except (OSError, ValueError):
            continue
        try:
            os.kill(j["owner"], 0)
        except ProcessLookupError:  # owner gone (crash/reboot): stale registration
            os.unlink(p)
            continue
        res[int(name)] = j
    return res


def main():
    os.makedirs(mg.KILLED, exist_ok=True)
    log(f"start: {mg.avail_gb():.1f} GiB available, swap used {mg.swap_used_gb():.1f} GiB")
    last_out, rates, last_log, peak = pswpout(), [], 0, {}
    while True:
        open(mg.HEARTBEAT, "w").close()
        time.sleep(5)
        cur = pswpout()
        rates = (rates + [(cur - last_out) * PAGE / 5 / (1 << 20)])[-3:]
        last_out = cur
        avail = mg.avail_gb()
        js = jobs()
        rss = rss_by_pgid()
        for g in js:
            peak[g] = max(peak.get(g, 0), rss.get(g, 0))
        for g in list(peak):
            if g not in js:
                log(f"job done pgid={g} peak_rss={peak.pop(g) / (1 << 30):.1f}G")
        swapping = len(rates) == 3 and min(rates) > SWAP_OUT_MB_S and avail < SWAP_AVAIL_GB
        if (avail < KILL_AVAIL_GB or swapping) and js:
            victim = max(js, key=lambda g: rss.get(g, 0))
            open(os.path.join(mg.KILLED, str(victim)), "w").close()
            try:
                os.killpg(victim, signal.SIGKILL)
            except ProcessLookupError:
                pass
            log(f"KILL pgid={victim} kind={js[victim]['kind']} rss={rss.get(victim, 0) / (1 << 30):.1f}G "
                f"avail={avail:.1f}G swapout={rates} cmd={js[victim]['cmd'][:150]}")
            rates = []
            time.sleep(10)
            continue
        if time.time() - last_log >= 60:
            last_log = time.time()
            desc = " ".join(f"{j['kind']}:{rss.get(g, 0) / (1 << 30):.1f}G" for g, j in sorted(js.items()))
            log(f"avail={avail:.1f}G swap={mg.swap_used_gb():.1f}G swapout={rates[-1] if rates else 0:.0f}MB/s "
                f"jobs={len(js)} {desc}")


if __name__ == "__main__":
    main()
