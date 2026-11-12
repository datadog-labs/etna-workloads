"""Summarise candidates.jsonl + probe.jsonl: by year, test kind, signal and apply status."""
import json, sys, collections, datetime
C = {json.loads(l)["sha"]: json.loads(l) for l in open(sys.argv[1])}
P = {json.loads(l)["sha"]: json.loads(l)["apply"] for l in open(sys.argv[2])}
def kind(c):
    k = set(c["test_kinds"]); s = {"slt", "slt_slow"} & k
    return ("slt" if s else "") + ("+cpp" if "cpp" in k else "") or "?"
tab = collections.defaultdict(collections.Counter)
for sha, c in C.items():
    y = datetime.datetime.utcfromtimestamp(c["time"]).year
    a = P[sha]
    for dim, v in (("year", y), ("test kind", kind(c)), ("signal", c["signal"])):
        tab[(dim, v)][a] += 1; tab[(dim, v)]["n"] += 1
    tab[("all", "")][a] += 1; tab[("all", "")]["n"] += 1
print(f"{'dimension':10s} {'value':16s} {'n':>5s} {'clean':>6s} {'fuzzy':>6s} {'confl':>6s}")
for (d, v), ct in sorted(tab.items(), key=lambda x: (x[0][0], str(x[0][1]))):
    print(f"{d:10s} {str(v):16s} {ct['n']:5d} {ct['clean']:6d} {ct['fuzzy']:6d} {ct['conflict']:6d}")
