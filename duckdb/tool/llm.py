"""Headless Claude calls with spend accounting.

Every call appends to results/ledger.jsonl {stage, cost, ok, ...}. A stage cap is enforced by the
caller via spent(stage). API/credential errors are returned as retryable, never as results.
"""
import fcntl, json, os, subprocess, time
import common

LEDGER = os.path.join(common.RESULTS, "ledger.jsonl")
RETRYABLE = ("credential", "api key", "apikeyhelper", "401", "403", "429", "overloaded", "rate limit",
             "timed out", "timeout", "connection", "econnreset", "529", "500", "502", "503", "internal server")


def record(entry):
    os.makedirs(common.RESULTS, exist_ok=True)
    entry["t"] = time.time()
    with open(LEDGER, "a") as f:
        fcntl.flock(f, fcntl.LOCK_EX)
        f.write(json.dumps(entry) + "\n")


def spent(stage=None):
    tot = 0.0
    for e in common.load_jsonl(LEDGER):
        if stage is None or e.get("stage") == stage:
            tot += e.get("cost", 0.0)
    return tot


def credential_ok():
    """Cheap probe of the credential helper / gateway before launching anything."""
    r = ask("Reply with exactly OK.", "ping", stage="probe", model="haiku", timeout=120, record_it=False)
    return r["ok"] and "OK" in (r["text"] or "")


def ask(system, prompt, stage, model="haiku", timeout=600, record_it=True, meta=None):
    cmd = ["claude", "-p", "--model", model, "--tools", "", "--strict-mcp-config", "--setting-sources", "",
           "--system-prompt", system, "--output-format", "json", "--no-session-persistence"]
    try:
        p = subprocess.run(cmd, input=prompt, capture_output=True, text=True, timeout=timeout,
                           cwd=os.path.join(common.WORK, "scratch"))
        out = p.stdout
    except subprocess.TimeoutExpired:
        return {"ok": False, "retryable": True, "error": "timeout", "text": None, "cost": 0}
    try:
        d = json.loads(out)
    except json.JSONDecodeError:
        err = (p.stderr or out or "")[-500:]
        return {"ok": False, "retryable": True, "error": err, "text": None, "cost": 0}
    cost = d.get("total_cost_usd") or 0.0
    res = {"ok": not d.get("is_error"), "text": d.get("result"), "cost": cost,
           "model": list(d.get("modelUsage", {}).keys())}
    if d.get("is_error"):
        e = str(d.get("result", ""))[:500]
        res.update(error=e, retryable=any(k in e.lower() for k in RETRYABLE) or True)
    if record_it:
        record({"stage": stage, "cost": cost, "ok": res["ok"], **(meta or {})})
    return res


def parse_claude_json(text):
    """Find the result object that `claude -p --output-format json` printed (stderr may be mixed in)."""
    best = {}
    for line in text.splitlines():
        line = line.strip()
        if line.startswith("{") and '"total_cost_usd"' in line:
            try:
                best = json.loads(line)
            except json.JSONDecodeError:
                pass
    return best


API_ERROR_RE = __import__("re").compile(r"apiKeyHelper|API Error|authenticat|credential|\b(401|403|429|5\d\d)\b.*(error|status)|"
                                        r"overloaded|rate.?limit|Could not connect|ECONNRESET", __import__("re").I)


def is_api_error(text):
    return bool(text) and bool(API_ERROR_RE.search(text))
