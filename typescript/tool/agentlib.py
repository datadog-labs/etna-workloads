"""Shared helpers for model calls: credential pre-check, spend ledger, caps."""
import fcntl, json, os, subprocess, time

import tstree

LEDGER = os.path.join(tstree.WORK, "spend.jsonl")
CAPS = os.path.join(tstree.WORK, "caps.json")
# Credential pre-check: a command that prints an API token, e.g. your apiKeyHelper.
# Set ETNA_CRED_HELPER (shell command); if unset, the check is skipped.
HELPER = os.environ.get("ETNA_CRED_HELPER")


class CapReached(Exception):
    pass


def cred_ok():
    if not HELPER:
        return True
    try:
        r = subprocess.run(HELPER, shell=True, capture_output=True, timeout=60)
        return r.returncode == 0 and len(r.stdout.strip()) > 20
    except Exception:
        return False


def wait_for_creds(max_wait=3600):
    t = time.time()
    delay = 30
    while not cred_ok():
        if time.time() - t > max_wait:
            raise RuntimeError("credential helper failing for over an hour")
        print(f"[agentlib] credential helper failed; retrying in {delay}s", flush=True)
        time.sleep(delay)
        delay = min(delay * 2, 300)


def spent(stage=None):
    tot = 0.0
    if os.path.exists(LEDGER):
        for line in open(LEDGER):
            e = json.loads(line)
            if stage is None or e["stage"] == stage:
                tot += e["usd"]
    return tot


def cap(stage):
    if not os.path.exists(CAPS):
        return 0.0
    return json.load(open(CAPS)).get(stage, 0.0)


def check_cap(stage, reserve=0.0):
    if spent(stage) + reserve > cap(stage):
        raise CapReached(f"{stage}: spent {spent(stage):.2f} of cap {cap(stage):.2f}")


def record(stage, usd, **meta):
    with open(LEDGER, "a") as f:
        fcntl.flock(f, fcntl.LOCK_EX)
        f.write(json.dumps({"t": time.time(), "stage": stage, "usd": usd, **meta}) + "\n")


def claude(args, cwd, stage, timeout, log_path, meta=None, env=None, rss_mb=6144):
    """Run `claude -p ... --output-format json`. Returns parsed JSON or a dict with
    retryable=True on API/credential errors. Records cost in the ledger."""
    import proc
    wait_for_creds()
    out_path = log_path + ".json"
    rc, reason = proc.run(["claude", "-p", *args, "--output-format", "json"], cwd, log_path,
                          timeout=timeout, rss_mb=rss_mb, env=env, stdout_path=out_path)
    raw = open(out_path, "rb").read().decode(errors="replace")
    data = None
    for line in reversed(raw.strip().splitlines()):
        try:
            data = json.loads(line)
            break
        except ValueError:
            continue
    if data is None:
        # Killed or crashed before the final JSON: cost unknown, so book the
        # per-call budget (conservative) and mark retryable.
        budget = float((meta or {}).get("budget", 0))
        record(stage, budget, estimated=True, **(meta or {}))
        return {"retryable": True, "why": f"no result json (rc={rc}, killed={reason})"}
    usd = float(data.get("total_cost_usd") or 0)
    record(stage, usd, **(meta or {}))
    if data.get("is_error") and any(s in str(data.get("result", "")).lower()
                                    for s in ("api error", "overloaded", "rate limit", "authentication",
                                              "credit", "invalid api key", "529", "500", "timeout")):
        data["retryable"] = True
    data["killed"] = reason
    return data
