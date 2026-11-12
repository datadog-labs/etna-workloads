#!/usr/bin/env python3
"""Funnel and spend summary from results/ (safe to run while the chain is going)."""
import collections, json, os, datetime
import common, classify, llm

cands = {c["sha"]: c for c in common.candidates()}
um = common.units_map(); base = common.base_oracle()
out = {}
for tier in ("verbatim", "adapted"):
    d = os.path.join(common.RESULTS, tier)
    v = collections.Counter(); strict = collections.Counter(); rep = collections.Counter()
    for s in os.listdir(d) if os.path.isdir(d) else []:
        p = os.path.join(d, s, "result.json")
        if not os.path.exists(p) or s not in cands:
            continue
        r = json.load(open(p)); v[r.get("verdict")] += 1
        if r.get("verdict") == "pass":
            cl = classify.classify(tier, r, cands[s], um, base)
            strict["strict" if cl["strict"] else "looser"] += 1
            rep[cl["repro_method"] or "none"] += 1
            for why in cl["not_strict_because"]:
                strict["  not strict: " + why] += 1
    out[tier] = {"verdicts": dict(v), "gate-pass": dict(strict), "reproducers": dict(rep)}
a = collections.Counter(json.load(open(os.path.join(common.RESULTS, "anchor", s, "result.json"))).get("status")
                        for s in os.listdir(os.path.join(common.RESULTS, "anchor"))
                        if os.path.exists(os.path.join(common.RESULTS, "anchor", s, "result.json")))
out["anchor"] = dict(a)
out["spend"] = {k: round(llm.spent(k), 2) for k in ("triage", "adapted", "repro")}
out["spend"]["total"] = round(sum(out["spend"].values()), 2)
print(json.dumps(out, indent=1))
