"""Headless Claude invocations with cost accounting and credential-helper checks."""
import json, os, subprocess, time
from common import *

# Optional Claude Code apiKeyHelper command (e.g. a site-specific token command); when unset,
# the claude CLI's own authentication is used.
HELPER = os.environ.get("ETNA_API_KEY_HELPER", "")
SETTINGS = json.dumps({"apiKeyHelper": HELPER} if HELPER else {})
SPEND = DATA / "spend.jsonl"


def helper_ok():
    if not HELPER:
        return True
    try:
        return subprocess.run(HELPER, shell=True, capture_output=True, timeout=60).returncode == 0
    except subprocess.TimeoutExpired:
        return False


def wait_helper(max_wait=6 * 3600):
    t = time.time()
    while not helper_ok():
        if time.time() - t > max_wait:
            raise RuntimeError("credential helper failing")
        time.sleep(60)


_last_api_ok = [0.0]


def api_ok():
    """One tiny real API call: the credential helper can work while the API refuses (403)."""
    try:
        r = subprocess.run(["claude", "-p", "--bare", "--settings", SETTINGS, "--model", "haiku",
                            "--output-format", "json", "--no-session-persistence", "--tools", ""],
                           input="Reply with: ok", capture_output=True, text=True, timeout=120,
                           cwd=WORK / "agent-tmp")
        d = json.loads(r.stdout)
        record("api-probe", "probe", d.get("total_cost_usd") or 0.0)
        return not d.get("is_error")
    except Exception:
        return False


def wait_api(max_wait=12 * 3600):
    """Before launching: credential helper works AND the API answers (probe at most every 10 min)."""
    wait_helper(max_wait)
    if time.time() - _last_api_ok[0] < 600:
        return
    t = time.time()
    while not api_ok():
        if time.time() - t > max_wait:
            raise RuntimeError("API unavailable")
        time.sleep(300)
    _last_api_ok[0] = time.time()


def spent(stage=None):
    if not SPEND.exists():
        return 0.0
    tot = 0.0
    for l in SPEND.read_text().splitlines():
        d = json.loads(l)
        if stage is None or d["stage"] == stage:
            tot += d["cost"]
    return tot


def record(stage, key, cost, extra=None):
    DATA.mkdir(parents=True, exist_ok=True)
    with open(SPEND, "a") as f:
        f.write(json.dumps(dict(stage=stage, key=key, cost=cost, t=time.time(), **(extra or {}))) + "\n")


def run_claude(prompt, stage, key, model="haiku", cwd=None, tools="", extra_args=(),
               timeout=600, budget=None):
    """Returns (result_text or None, info dict). API errors -> result None, info['retryable']=True."""
    wait_api()
    args = ["claude", "-p", "--bare", "--settings", SETTINGS, "--model", model,
            "--output-format", "json", "--no-session-persistence", "--tools", tools, *extra_args]
    if budget:
        args += ["--max-budget-usd", str(budget)]
    cwd = cwd or (WORK / "agent-tmp")
    os.makedirs(cwd, exist_ok=True)
    try:
        r = subprocess.run(args, input=prompt, capture_output=True, text=True, cwd=cwd, timeout=timeout)
    except subprocess.TimeoutExpired:
        return None, dict(retryable=True, error="timeout")
    try:
        d = json.loads(r.stdout)
    except Exception:
        return None, dict(retryable=True, error="bad-json", stderr=r.stderr[-1000:], stdout=r.stdout[-1000:])
    cost = d.get("total_cost_usd") or 0.0
    record(stage, key, cost, dict(model=model, turns=d.get("num_turns")))
    if d.get("is_error"):
        return None, dict(retryable=True, error=str(d.get("result"))[:500], cost=cost, subtype=d.get("subtype"))
    return d.get("result"), dict(cost=cost, turns=d.get("num_turns"), subtype=d.get("subtype"))
