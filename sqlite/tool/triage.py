#!/usr/bin/env python3
"""Triage: is each candidate commit a bug fix, and what kind of bug?

Batches of commits (message + implementation diff, truncated) go to a Claude
model without tools; it returns one JSON label per commit:

  kind       bug | feature | performance | refactor | test_build_doc
  symptom    wrong_result | crash | assert | corruption | error_handling |
             resource_leak | hang | other | none
  subsystem  e.g. planner, vdbe, btree, pager, wal, fts3, fts5, rtree, json,
             window, parser, alter, trigger, os, session, expr, func, other
  confidence high | medium | low
  reason     one sentence

Only kind=bug candidates go on to the adapted tier, and the dataset export
uses kind/symptom/subsystem as labels (verbatim results included).

Usage:
  triage.py [-j N] [--batch K] [--model M] [--ids a,b]
"""

import argparse
import json
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import sqlite_etna as E  # noqa: E402

DIFF_LINES = 160

PROMPT = """\
You are labelling commits from {name}'s history for a benchmark of real bugs.
For each commit below (message and implementation diff, possibly truncated),
decide:

- kind: "bug" if the commit corrects behaviour that was wrong before it
  (wrong query results, crashes, assertion faults, corruption, incorrect
  error handling, leaks, hangs, undefined behaviour, security issues),
  even if it also adds tests. "feature" for new functionality or changed
  intended behaviour (including better error messages or new limits that
  were not a defect), "performance" for speed/memory improvements with no
  wrong behaviour, "refactor" for restructuring or cleanup, "test_build_doc"
  when the implementation change is incidental (build system, test hooks,
  comments, coverage annotations).
- symptom (for bugs; "none" otherwise): wrong_result, crash, assert,
  corruption, error_handling, resource_leak, hang, other.
- subsystem: a short lowercase tag (planner, vdbe, btree, pager, wal, fts3,
  fts5, rtree, json, window, parser, alter, trigger, os, session, expr,
  func, other, ...).
- confidence: high, medium or low. reason: one short sentence.

Reply with ONLY a JSON array, one object per commit, in the same order:
[{{"id": "<id>", "kind": ..., "symptom": ..., "subsystem": ..., "confidence": ..., "reason": ...}}]

{commits}
"""


def describe(c):
    body = E.git("log", "-1", "--format=%B", c["id"]).stdout.strip()
    diff = E.git("diff", f"{c['id']}^1", c["id"], "--", *c["impl_files"]).stdout.splitlines()
    more = f"\n... ({len(diff) - DIFF_LINES} more diff lines)" if len(diff) > DIFF_LINES else ""
    return (f"=== id: {c['id'][:12]}  date: {c['date'][:10]}\n{body}\n--- diff ---\n"
            + "\n".join(diff[:DIFF_LINES]) + more + "\n")


def classify(batch, model):
    prompt = PROMPT.format(name=E.NAME, commits="\n".join(describe(c) for c in batch))
    E.wait_for_auth()
    r = subprocess.run(
        [os.environ.get("CLAUDE_BIN", os.path.expanduser("~/.local/bin/claude")), "-p",
         "--model", model, "--output-format", "json", "--max-turns", "1"],
        input=prompt, capture_output=True, text=True, timeout=900)
    meta = json.loads(r.stdout)
    text = meta.get("result", "")
    start, end = text.find("["), text.rfind("]")
    labels = json.loads(text[start:end + 1])
    cost = meta.get("total_cost_usd") or 0
    byid = {l["id"][:12]: l for l in labels if isinstance(l, dict) and "id" in l}
    out = []
    for c in batch:
        l = byid.get(c["id"][:12])
        if l:
            out.append({**l, "id": c["id"], "model": model})
    return out, cost


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-j", type=int, default=8)
    ap.add_argument("--batch", type=int, default=20)
    ap.add_argument("--model", default="claude-sonnet-5-5")
    ap.add_argument("--ids", default="")
    a = ap.parse_args()
    cands = E.candidates()
    done = E.latest("triage")
    ids = a.ids.split(",") if a.ids else [i for i in cands if i not in done]
    todo = sorted((cands[i] for i in ids if i in cands), key=lambda c: c["date"])
    batches = [todo[i:i + a.batch] for i in range(0, len(todo), a.batch)]
    print(f"{len(todo)} commits in {len(batches)} batches", flush=True)
    total = 0.0
    with ThreadPoolExecutor(a.j) as ex:
        futs = {ex.submit(classify, b, a.model): b for b in batches}
        for n, fu in enumerate(as_completed(futs), 1):
            try:
                labels, cost = fu.result()
            except Exception as e:
                print(f"  batch failed: {str(e)[:200]}", flush=True)
                continue
            total += cost
            for l in labels:
                E.append("triage", l)
            if n % 10 == 0 or n == len(batches):
                print(f"  {n}/{len(batches)} batches, ${total:.2f}", flush=True)


if __name__ == "__main__":
    main()
