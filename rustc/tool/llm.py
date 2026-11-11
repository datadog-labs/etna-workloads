"""Headless claude CLI wrapper with credential check, spend ledger and retry."""
import json
import os
import shlex
import subprocess
import time

from common import DATA

LEDGER = os.path.join(DATA, "spend.jsonl")
# Command that exits 0 while API credentials are valid (checked before every agent launch);
# site-specific, so it comes from the environment.  Unset: no check.
HELPER = shlex.split(os.environ.get("ETNA_CREDENTIAL_HELPER", ""))


def credential_ok():
    try:
        return not HELPER or subprocess.run(HELPER, capture_output=True, timeout=60).returncode == 0
    except Exception:  # noqa: BLE001
        return False


def wait_for_credentials(max_wait=6 * 3600):  # a lapsed helper pauses launches; raise only after 6 h
    t = time.time()
    while not credential_ok():
        if time.time() - t > max_wait:
            raise RuntimeError("credential helper failing")
        time.sleep(60)


def spent(stage=None):
    if not os.path.exists(LEDGER):
        return 0.0
    tot = 0.0
    for line in open(LEDGER):
        r = json.loads(line)
        if stage is None or r["stage"] == stage:
            tot += r.get("cost", 0.0)
    return tot


def record(stage, key, cost, extra=None):
    with open(LEDGER, "a") as f:
        f.write(json.dumps(dict(stage=stage, key=key, cost=cost, t=time.time(), **(extra or {}))) + "\n")


def ask(prompt, stage, key, model="claude-haiku-5-5", system="You are a careful classifier.",
        schema=None, cwd=None, timeout=600, retries=3, effort=None):
    """Single tool-less call. Returns (parsed_result_or_text, cost). Raises on repeated API errors."""
    cmd = ["claude", "-p", "--model", model, "--output-format", "json", "--setting-sources", "user",
           "--system-prompt", system, "--tools", "", "--strict-mcp-config", "--no-session-persistence"]
    if schema:
        cmd += ["--json-schema", json.dumps(schema)]
    if effort:
        cmd += ["--effort", effort]
    last = None
    for attempt in range(retries):
        wait_for_credentials()
        try:
            r = subprocess.run(cmd, input=prompt, capture_output=True, text=True, timeout=timeout, cwd=cwd)
            d = json.loads(r.stdout)
        except Exception as e:  # noqa: BLE001
            last = repr(e)
            time.sleep(10 * (attempt + 1))
            continue
        cost = d.get("total_cost_usd") or 0.0
        record(stage, key, cost)
        if d.get("is_error"):
            last = d.get("result")
            time.sleep(10 * (attempt + 1))
            continue
        out = d.get("structured_output") if schema else None
        return (out if out is not None else d.get("result")), cost
    raise RuntimeError(f"api error (retryable): {last}")
