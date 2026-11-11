"""Funnel, strict counts, spend.  Also provides strict_set() / bugs() for other stages."""
import json
from collections import Counter, defaultdict
from common import *
import llm


def bugs():
    """All gated bugs (verbatim or adapted) with their labels."""
    tri = load("triage.json", {})
    cands = {c["sha"]: c for c in load("candidates.json")}
    out = []
    for tier, d in (("verbatim", "verbatim"), ("adapted", "adapted")):
        for f in (DATA / d).glob("*.json"):
            r = json.loads(f.read_text())
            if not r.get("gate") or r.get("retryable") or r["sha"] not in cands:
                continue
            c = cands[r["sha"]]
            t = tri.get(r["sha"], {})
            a = None
            if tier == "adapted":
                af = DATA / "anchor" / f.name
                a = json.loads(af.read_text())["anchor"] if af.exists() else "not-run"
            trv = DATA / "trace" / f.name
            trace = json.loads(trv.read_text()) if trv.exists() else None
            rp = DATA / "repro" / f.name
            rp = json.loads(rp.read_text()) if rp.exists() else {}
            b = dict(sha=r["sha"], tier=tier, mode=r.get("mode"), date=c["date"], subject=c["subject"],
                     label=t.get("label"), symptom=t.get("symptom"), subsystem=t.get("subsystem"),
                     fails_added=bool(r.get("fails_added")), failing=r["failing"], anchor=a,
                     locality=r.get("locality", "same-files"), repro=bool(rp.get("verified")))
            # adapted rule: every injected hunk must trace to a hunk of the fix (judge + hand check)
            b["trace"] = None if tier == "verbatim" else \
                (trace["verdict"] + ("+exceeds" if trace.get("exceeds_fix") else "") if trace else "unchecked")
            traced = tier == "verbatim" or b["trace"] == "traces"
            b["strict"] = bool(b["fails_added"] and b["label"] == "bug" and traced and
                               (tier == "verbatim" or a == "exact"))
            b["files"] = sorted(r["files"])
            out.append(b)
    out.sort(key=lambda b: b["date"], reverse=True)
    # Near-duplicates (same fix split over commits, or "take 2"): strict bugs failing the same
    # oracle cases with injections in the same files. Newest stays strict; others are labelled.
    seen = {}
    for b in out:
        b["duplicate_of"] = None
        if not b["strict"]:
            continue
        key = (tuple(sorted(b["failing"])), tuple(b["files"]))
        if key in seen:
            b["duplicate_of"] = seen[key]
            b["strict"] = False
        else:
            seen[key] = b["sha"]
    return out


def strict_set():
    return {b["sha"] for b in bugs() if b["strict"]}


def main():
    cands = load("candidates.json")
    tri = load("triage.json", {})
    probe = {r["sha"]: r for r in load("probe.json")}
    print("candidates:", len(cands), "  triaged:", len(tri), dict(Counter(v["label"] for v in tri.values())))
    for name in ("verbatim", "adapted", "anchor", "repro"):
        rs = [json.loads(f.read_text()) for f in (DATA / name).glob("*.json")] if (DATA / name).exists() else []
        print(f"\n[{name}] records: {len(rs)}")
        if name == "verbatim":
            print("  mode:", dict(Counter(r.get("mode") for r in rs)), " build:", dict(Counter(r.get("build") for r in rs)),
                  " skip:", dict(Counter(r.get("skip") for r in rs if r.get("skip"))), " gate:", sum(bool(r.get("gate")) for r in rs))
        if name == "adapted":
            print("  gate:", sum(bool(r.get("gate")) for r in rs), " skip:", dict(Counter(r.get("skip") for r in rs if r.get("skip"))),
                  " build:", dict(Counter(r.get("build") for r in rs)), " retryable:", sum(bool(r.get("retryable")) for r in rs),
                  " classifier-blocked:", sum(bool(r.get("classifier_blocked")) for r in rs),
                  " models:", dict(Counter(r.get("model") for r in rs)),
                  " locality(gated):", dict(Counter(r.get("locality") for r in rs if r.get("gate"))))
        if name == "anchor":
            print("  ", dict(Counter(r.get("anchor") for r in rs)))
        if name == "repro":
            print("  verified:", sum(bool(r.get("verified")) for r in rs), " why:", dict(Counter(r.get("why") or r.get("skip") for r in rs if not r.get("verified"))))
    bs = bugs()
    st = [b for b in bs if b["strict"]]
    print(f"\ngated bugs: {len(bs)}  by tier {dict(Counter(b['tier'] for b in bs))}")
    print(f"  fails in fix-added test: {sum(b['fails_added'] for b in bs)}  triage=bug: {sum(b['label']=='bug' for b in bs)}")
    print(f"  strict-eligible but near-duplicate: {sum(bool(b['duplicate_of']) for b in bs)}"
          f"   adapted failing traceability: {sum(1 for b in bs if b['tier']=='adapted' and b['trace']!='traces')}")
    print(f"STRICT: {len(st)}  by tier {dict(Counter(b['tier'] for b in st))}")
    print("  by symptom", dict(Counter(b["symptom"] for b in st)))
    print("  by year", dict(sorted(Counter(b["date"][:4] for b in st).items())))
    print("  with verified reproducer:", sum(b["repro"] for b in st), "/", len(st), "  (all gated:", sum(b["repro"] for b in bs), "/", len(bs), ")")
    print("\nspend by stage:", {s: round(llm.spent(s), 3) for s in ("triage", "adapted", "adapted-retry", "repro", "trace-check", "api-probe", "sbx-check")},
          " total", round(llm.spent(), 3))


if __name__ == "__main__":
    main()
