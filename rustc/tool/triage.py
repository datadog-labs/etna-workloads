#!/usr/bin/env python3
"""Triage every candidate with a cheap model.

usage: triage.py [--cap USD] [--limit N] [--workers 8]
Output: data/triage/<commit>.json  (resumable).
"""
import argparse
import json
import os
import sys
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, git  # noqa: E402
import llm  # noqa: E402

OUT = os.path.join(DATA, "triage")
SCHEMA = {
    "type": "object",
    "properties": {
        "label": {"type": "string", "enum": ["bug", "feature", "performance", "refactor", "test-build-doc"]},
        "symptom": {"type": "string", "enum": [
            "ice", "spurious-error", "accepts-invalid", "wrong-diagnostic", "missing-diagnostic",
            "bad-suggestion", "miscompile", "wrong-mir-or-codegen", "hang-or-overflow",
            "unsound", "incremental", "other", "none"]},
        "subsystem": {"type": "string"},
        "confidence": {"type": "number"},
        "reason": {"type": "string"},
    },
    "required": ["label", "symptom", "subsystem", "confidence", "reason"],
    "additionalProperties": False,
}
SYSTEM = ("You classify commits of the Rust compiler (rustc). Decide whether the commit fixes a bug "
          "(the compiler behaved incorrectly: ICE, wrong or misleading diagnostic, bad suggestion, "
          "rejecting valid code, accepting invalid code, miscompilation, unsoundness, hang) versus "
          "adding a feature, a performance change, a refactor/cleanup, or only tests/build/docs. "
          "Diagnostic wording improvements count as bug only if the old output was wrong or "
          "misleading. Answer with the requested JSON.")


def prompt_for(c):
    diff = git("diff", "--no-renames", "--stat=120", f"{c['commit']}^", c["commit"])
    impl = git("diff", "--no-renames", f"{c['commit']}^", c["commit"], "--", *c["impl_files"])
    if len(impl) > 9000:
        impl = impl[:9000] + "\n[... diff truncated ...]"
    return (f"Commit subject: {c['subject']}\n\nCommit message:\n{c['body'][:2500]}\n\n"
            f"Pull request #{c.get('pr')}: {c.get('pr_title', '')}\n"
            f"Issues referenced as fixed: {', '.join('#%d' % n for n in c['issue_refs']) or 'none'}\n\n"
            f"Diffstat:\n{diff[-3000:]}\n\nImplementation diff:\n{impl}\n")


def triage(c):
    p = os.path.join(OUT, f"{c['commit']}.json")
    if os.path.exists(p):
        return 0.0
    try:
        out, cost = llm.ask(prompt_for(c), "triage", c["commit"], schema=SCHEMA, system=SYSTEM, effort="low")
    except RuntimeError as e:
        print("retryable:", c["commit"][:10], e, flush=True)
        return 0.0
    if not isinstance(out, dict):
        print("unparsed:", c["commit"][:10], str(out)[:200], flush=True)
        return cost
    out["commit"] = c["commit"]
    json.dump(out, open(p, "w"))
    return cost


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cap", type=float, default=10.0)
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--workers", type=int, default=8)
    ap.add_argument("--only", nargs="*")
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    cands = [json.loads(line) for line in open(os.path.join(DATA, "candidates.jsonl"))]
    cands.sort(key=lambda c: c["date"], reverse=True)
    if a.only:
        cands = [c for c in cands if any(c["commit"].startswith(x) for x in a.only)]
    cands = [c for c in cands if not os.path.exists(os.path.join(OUT, f"{c['commit']}.json"))]
    if a.limit:
        cands = cands[:a.limit]
    print(f"{len(cands)} to triage; spent so far {llm.spent('triage'):.2f}", flush=True)

    import threading
    total = [llm.spent("triage")]
    lock = threading.Lock()

    def job(c):
        with lock:
            if total[0] >= a.cap:
                return 0.0
        cost = triage(c)
        with lock:
            total[0] += cost
        return cost

    with ThreadPoolExecutor(a.workers) as ex:
        list(ex.map(job, cands))
    print(f"triage spend total {llm.spent('triage'):.2f}")


if __name__ == "__main__":
    main()
