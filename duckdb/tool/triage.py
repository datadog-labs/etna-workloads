#!/usr/bin/env python3
"""Triage every candidate with a cheap model: label, symptom, subsystem, confidence.

usage: triage.py [--cap USD] [--limit N] [--jobs J] [--model haiku]
Output: results/triage/<sha>.json. Resumable; stops when the stage spend reaches --cap.
"""
import argparse, json, os, re, sys, time
from concurrent.futures import ThreadPoolExecutor
import common, llm

SYSTEM = """You classify commits of the DuckDB database engine for a bug dataset.
Given a commit (message, PR title, changed files, implementation diff), answer with ONE JSON object
and nothing else:
{"label": "bug"|"feature"|"performance"|"refactor"|"test-build-doc",
 "symptom": "wrong-result"|"crash"|"assertion"|"internal-error"|"spurious-error"|"missing-error"|"hang"|"memory"|"other"|"none",
 "subsystem": short lowercase name such as "optimizer", "binder", "parser", "execution/join", "storage", "catalog", "function/scalar", "csv", "transaction", "types/cast", "window", "aggregate", "api",
 "confidence": number between 0 and 1,
 "summary": one sentence describing the bug the commit fixes (or what it does if not a bug fix)}
Label "bug" only if the implementation change corrects incorrect behaviour that existed before
(wrong results, crashes, assertion/internal errors, wrong or missing error messages, hangs, leaks).
New functionality, options or syntax are "feature" even if the message says "fix"; speedups are
"performance"; pure restructuring is "refactor"; changes whose substance is tests, CI, build or docs
are "test-build-doc"."""


def prompt_for(c):
    diff = common.impl_diff(c["sha"], c["parent"]).decode("utf-8", "replace")
    if len(diff) > 12000:
        diff = diff[:12000] + "\n... [diff truncated]"
    return (f"Commit subject: {c['subject']}\n\nCommit body:\n{c['body'][:2000]}\n\n"
            f"PR title: {c.get('pr_title') or ''}\nIssue refs: {', '.join(c['issues'])}\n"
            f"Implementation files: {', '.join(c['impl'][:30])}\nTest files: {', '.join(c['tests'][:20])}\n\n"
            f"Implementation diff (src/):\n{diff}")


def parse(text):
    m = re.search(r"\{.*\}", text or "", re.S)
    if not m:
        return None
    try:
        d = json.loads(m.group(0))
    except json.JSONDecodeError:
        return None
    return d if d.get("label") in ("bug", "feature", "performance", "refactor", "test-build-doc") else None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cap", type=float, required=True); ap.add_argument("--limit", type=int)
    ap.add_argument("--jobs", type=int, default=8); ap.add_argument("--model", default="haiku")
    ap.add_argument("--shas")
    a = ap.parse_args()
    outdir = os.path.join(common.RESULTS, "triage"); os.makedirs(outdir, exist_ok=True)
    cands = common.candidates()
    if a.shas:
        keep = {l.split()[0] for l in open(a.shas) if l.strip()}
        cands = [c for c in cands if c["sha"] in keep]
    todo = [c for c in cands if not os.path.exists(os.path.join(outdir, c["sha"] + ".json"))]
    if a.limit:
        todo = todo[:a.limit]
    while not llm.credential_ok():
        print("credential probe failed; retrying in 120s", flush=True); time.sleep(120)

    def one(c):
        for attempt in range(4):
            if llm.spent("triage") >= a.cap or os.path.exists(os.path.join(common.WORK, "STOP")):
                return "cap"
            r = llm.ask(SYSTEM, prompt_for(c), stage="triage", model=a.model, meta={"sha": c["sha"]})
            d = parse(r["text"]) if r["ok"] else None
            if d:
                d.update(sha=c["sha"], model=r["model"], cost=r["cost"])
                common.write_json(os.path.join(outdir, c["sha"] + ".json"), d)
                return "ok"
            time.sleep(20 * (attempt + 1))
            while not r["ok"] and not llm.credential_ok():
                time.sleep(120)
        return "failed"
    from collections import Counter
    with ThreadPoolExecutor(a.jobs) as ex:
        st = Counter(ex.map(one, todo))
    print(st, "triage spend so far $%.2f" % llm.spent("triage"))


if __name__ == "__main__":
    main()
