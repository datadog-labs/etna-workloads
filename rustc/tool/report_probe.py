#!/usr/bin/env python3
"""Summarise data/candidates.jsonl + data/probe.jsonl for the probe checkpoint."""
import json, os, sys
from collections import Counter, defaultdict
sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, ORACLE_SUITES
cs = {json.loads(l)["commit"]: json.loads(l) for l in open(os.path.join(DATA, "candidates.jsonl"))}
pr = {json.loads(l)["commit"]: json.loads(l) for l in open(os.path.join(DATA, "probe.jsonl"))}
ST = ["clean", "fuzzy", "partial", "conflict"]
def row(label, items):
    c = Counter(pr[h]["status"] for h in items)
    print(f"{label:<14}{len(items):>6} " + " ".join(f"{c[s]:>8}" for s in ST))
print(f"{'':<14}{'total':>6} " + " ".join(f"{s:>8}" for s in ST))
row("all", list(cs))
orac = [h for h in cs if set(cs[h]["suites"]) & ORACLE_SUITES]
row("oracle-suite", orac)
print("\nby year (oracle-suite candidates)")
by = defaultdict(list)
for h in orac: by[cs[h]["date"][:4]].append(h)
for y in sorted(by): row(y, by[y])
print("\nby test kind (a candidate can count in several)")
bk = defaultdict(list)
for h in cs:
    for s in cs[h]["suites"]: bk[s].append(h)
for s, hs in sorted(bk.items(), key=lambda x: -len(x[1]))[:18]: row(s, hs)
print("\nsignal: issue-ref", sum(1 for h in orac if cs[h]["issue_refs"]), " wording-only", sum(1 for h in orac if not cs[h]["issue_refs"]))
cf = [h for h in orac if pr[h]["status"] in ("clean", "fuzzy")]
print("clean+fuzzy oracle-suite:", len(cf))
print("  ... whose added test files all still exist at release:",
      sum(1 for h in cf if pr[h]["tests_added"] and pr[h]["tests_present"] == pr[h]["tests_added"]),
      " no added tests (modified only):", sum(1 for h in cf if not pr[h]["tests_added"]))
print("  ... touching only compiler/ (no library/ or src/ impl):", sum(1 for h in cf if not cs[h]["other_impl"]))
print("partial: median failed hunk share",
      sorted(pr[h]["failed_hunks"]/pr[h]["hunks"] for h in orac if pr[h]["status"]=="partial")[len([1 for h in orac if pr[h]["status"]=="partial"])//2])
print("crashes->ui moves among oracle cands:", sum(1 for h in orac if "crashes" in cs[h]["suites"] and "ui" in cs[h]["suites"]))
