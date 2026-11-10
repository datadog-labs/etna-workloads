"""Minimal Messages API client (raw HTTP; the anthropic SDK is not installed here).

Credentials come from the host's API key helper; the gateway URL and extra
headers from the environment Claude Code runs with.  Spend is computed from
the returned usage and appended to a ledger file.
"""
import json, os, subprocess, time, urllib.error, urllib.request

# Command that prints an API token (e.g. the apiKeyHelper of your Claude Code settings);
# falls back to ANTHROPIC_API_KEY when unset.
KEY_HELPER = os.environ.get("ETNA_API_KEY_HELPER")
# $ per million tokens: input, output, cache read, cache write (5m)
PRICES = {
    "claude-haiku-5-5": (0.10, 0.50, 0.01, 0.125),
    "claude-sonnet-5-5": (2.00, 10.00, 0.20, 2.50),
    "claude-opus-5-5": (4.00, 20.00, 0.20, 5.00),
}


class RetryableError(Exception):
    pass


def token():
    if not KEY_HELPER:
        if os.environ.get("ANTHROPIC_API_KEY"):
            return os.environ["ANTHROPIC_API_KEY"]
        raise RetryableError("no ETNA_API_KEY_HELPER or ANTHROPIC_API_KEY")
    p = subprocess.run(KEY_HELPER, shell=True, capture_output=True, text=True)
    if p.returncode != 0 or not p.stdout.strip():
        raise RetryableError("credential helper failed")
    return p.stdout.strip()


def headers(tok):
    h = {"content-type": "application/json", "anthropic-version": "2023-06-01",
         "x-api-key": tok, "authorization": "Bearer " + tok}
    for line in os.environ.get("ANTHROPIC_CUSTOM_HEADERS", "").split("\n"):
        if ":" in line:
            k, v = line.split(":", 1)
            h[k.strip()] = v.strip()
    return h


def cost(model, usage):
    pi, po, pr, pw = PRICES[model]
    return (usage.get("input_tokens", 0) * pi + usage.get("output_tokens", 0) * po
            + usage.get("cache_read_input_tokens", 0) * pr
            + usage.get("cache_creation_input_tokens", 0) * pw) / 1e6


def call(body, ledger=None, stage="", retries=6):
    url = os.environ.get("ANTHROPIC_BASE_URL", "https://api.anthropic.com") + "/v1/messages"
    last = None
    for attempt in range(retries):
        try:
            tok = token()
            req = urllib.request.Request(url, data=json.dumps(body).encode(), headers=headers(tok))
            d = json.load(urllib.request.urlopen(req, timeout=300))
            c = cost(body["model"], d.get("usage", {}))
            if ledger:
                with open(ledger, "a") as f:
                    f.write(json.dumps({"t": time.time(), "stage": stage, "model": body["model"],
                                        "usd": c, "usage": d.get("usage")}) + "\n")
            return d, c
        except urllib.error.HTTPError as e:
            last = f"HTTP {e.code}: {e.read()[:300]!r}"
            if e.code not in (408, 409, 429, 500, 502, 503, 504, 529):
                raise RetryableError(last)  # recorded as retryable, never as a result
        except (urllib.error.URLError, TimeoutError, RetryableError, ConnectionError) as e:
            last = str(e)
        time.sleep(min(60, 5 * 2 ** attempt))
    raise RetryableError(last)


def spent(ledger, stage=None):
    if not os.path.exists(ledger):
        return 0.0
    return sum(r["usd"] for r in map(json.loads, open(ledger)) if stage in (None, r["stage"]))
