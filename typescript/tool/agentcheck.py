#!/usr/bin/env python3
"""Agent-side build-and-test loop: rebuild TREE, run ORACLE units once, print
each oracle case's status. Also lists changed files and flags non-impl edits.

Usage: agentcheck.py TREE ORACLE.json [--no-build]
"""
import json, os, sys, time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import inject, tstree


def main(tree, oracle_path, *flags):
    tree = os.path.abspath(tree)
    oracle = json.load(open(oracle_path))
    logs = os.path.join(os.path.dirname(tree), "check-logs")
    os.makedirs(logs, exist_ok=True)
    stamp = time.strftime("%H%M%S")
    changed = inject.changed_impl_files(tree)
    print("changed files:", ", ".join(changed) or "(none)")
    bad = [p for p in changed if p.startswith(("src/lib/", "src/testRunner/", "src/harness/")) or not p.startswith("src/")]
    if bad:
        print("NOT ALLOWED (tests/test-only code/lib .d.ts):", ", ".join(bad))
    if "--no-build" not in flags:
        ok, reason = tstree.build(tree, f"{logs}/build-{stamp}.log")
        if not ok:
            lines = [l for l in open(f"{logs}/build-{stamp}.log", errors="replace") if "error" in l.lower()]
            print(f"BUILD FAILED ({reason or 'errors'}); first errors:")
            print("".join(lines[:20]))
            print(f"full log: {logs}/build-{stamp}.log")
            return 2
        print("build ok")
    units = sorted({(o["runner"], o["grep"]) for o in oracle.values()})
    j = f"{logs}/tests-{stamp}.jsonl"
    tstree.run_units(tree, units, j, f"{logs}/tests-{stamp}.log", timeout=1800)
    res, meta = tstree.parse(j)
    nf = nfa = 0
    for t, o in sorted(oracle.items()):
        st = tstree.case_status(res, t)
        nf += st == "fail"
        nfa += st == "fail" and o["added"]
        print(f"{st.upper():7} {'[fix-added] ' if o['added'] else ''}{t}")
    if meta["incomplete"]:
        print("incomplete runner groups (crash/timeout):", meta["incomplete"])
    errs = {}
    for line in open(j):
        e = json.loads(line)
        if e.get("ev") == "fail" and len(errs) < 5:
            errs[e["title"]] = e["err"][:800]
    for t, e in errs.items():
        print(f"\n--- failure: {t}\n{e}")
    print(f"\nSUMMARY: {nf}/{len(oracle)} oracle cases failing ({nfa} fix-added). "
          f"Local baselines (actual output) are in {tree}/tests/baselines/local/")
    return 0


if __name__ == "__main__":
    sys.exit(main(*sys.argv[1:]))
