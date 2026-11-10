#!/usr/bin/env python3
"""Triage every candidate with a cheap model: label, symptom, subsystem, confidence.

Resumable: results are appended to --out keyed by sha; already-triaged shas are
skipped.  Stops when the stage's spend reaches --cap-usd.
"""
import argparse, json, os, subprocess, sys
from concurrent.futures import ThreadPoolExecutor
import llm

MODEL = "claude-haiku-5-5"
MAX_DIFF = 30000  # chars of implementation diff shown; longer diffs are cut and marked

SCHEMA = {
    "type": "object", "additionalProperties": False,
    "required": ["label", "symptom", "subsystem", "confidence", "reason"],
    "properties": {
        "label": {"type": "string", "enum": ["bug", "feature", "performance", "refactor", "test-build-doc"]},
        "symptom": {"type": "string", "enum": ["crash", "wrong-output", "exception", "hang",
                                               "resource-leak", "security", "spec-violation",
                                               "missing-validation", "other"]},
        "subsystem": {"type": "string"},
        "confidence": {"type": "string", "enum": ["high", "medium", "low"]},
        "reason": {"type": "string"},
    },
}

PROMPT = """You are classifying a commit from the Node.js runtime repository.

Decide what the change to the implementation (lib/ JavaScript, src/ C++) does:
- bug: fixes incorrect behaviour that users could observe (crash, wrong result, wrong
  error, hang, leak, security hole, spec/documentation violation).
- feature: adds new API, option or behaviour that was not promised before.
- performance: speeds up or reduces memory without changing behaviour.
- refactor: restructures code without behaviour change (incl. lint, cleanup, deprecations
  that only add warnings).
- test-build-doc: the implementation part is incidental; the commit is about tests, build
  or docs.

symptom: the main user-visible symptom of the bug (or "other" if not a bug).
subsystem: the Node.js subsystem (e.g. fs, http, stream, crypto, module, test_runner, src).

Commit message:
<message>
{body}
</message>

Implementation diff:
<diff>
{diff}
</diff>"""


def diff_of(repo, c):
    d = subprocess.run(["git", "-C", repo, "diff", f"{c['sha']}^", c["sha"], "--", *c["impl_files"]],
                       capture_output=True, text=True, errors="replace").stdout
    if len(d) > MAX_DIFF:
        d = d[:MAX_DIFF] + f"\n[... diff cut, {len(d) - MAX_DIFF} more characters ...]"
    return d


def triage(repo, c, ledger):
    body = {"model": MODEL, "max_tokens": 2000,
            "output_config": {"effort": "low",
                              "format": {"type": "json_schema", "schema": SCHEMA}},
            "messages": [{"role": "user", "content": PROMPT.format(body=c["body"], diff=diff_of(repo, c))}]}
    d, usd = llm.call(body, ledger=ledger, stage="triage")
    text = "".join(b.get("text", "") for b in d["content"] if b["type"] == "text")
    r = json.loads(text)
    r.update(sha=c["sha"], model=MODEL, usd=usd)
    return r


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", required=True)
    ap.add_argument("--inp", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--ledger", required=True)
    ap.add_argument("--cap-usd", type=float, required=True)
    ap.add_argument("--limit", type=int)
    ap.add_argument("-j", type=int, default=8)
    a = ap.parse_args()
    done = set()
    if os.path.exists(a.out):
        done = {json.loads(l)["sha"] for l in open(a.out)}
    todo = [c for c in map(json.loads, open(a.inp)) if c["sha"] not in done]  # newest first
    if a.limit:
        todo = todo[:a.limit]
    errors = 0

    def work(c):
        nonlocal errors
        if llm.spent(a.ledger, "triage") >= a.cap_usd:
            return
        try:
            r = triage(a.repo, c, a.ledger)
        except (llm.RetryableError, json.JSONDecodeError, KeyError) as e:
            errors += 1
            print(f"retryable error {c['sha'][:10]}: {e}", file=sys.stderr)
            return
        with open(a.out, "a") as f:
            f.write(json.dumps(r) + "\n")

    with ThreadPoolExecutor(a.j) as ex:
        list(ex.map(work, todo))
    print(f"triaged {len(todo)} requested; errors {errors}; spent ${llm.spent(a.ledger, 'triage'):.2f}",
          file=sys.stderr)


if __name__ == "__main__":
    main()
