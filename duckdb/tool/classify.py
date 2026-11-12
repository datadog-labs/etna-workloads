"""Classify gated results into strict / looser tiers and compute locality (shared by report and export)."""
import json, os, re
import common


def triage(sha):
    p = f"{common.RESULTS}/triage/{sha}.json"
    return json.load(open(p)) if os.path.exists(p) else {}


def patch_files(patch_text):
    return sorted(set(re.findall(r"^diff --git a/(\S+) b/", patch_text, re.M)))


def locality(inj_files, fix_impl_files):
    s, f = set(inj_files), set(fix_impl_files)
    if not s:
        return "empty"
    if s <= f:
        return "same-files"
    if s & f:
        return "overlap"
    return "disjoint"


def anchor_of(sha):
    p = f"{common.RESULTS}/anchor/{sha}/result.json"
    return json.load(open(p)) if os.path.exists(p) else None


def classify(tier, r, cand, umap, base):
    """Return dict with gate, strict and the reasons a bug is not strict."""
    out = {"tier": tier, "gate": r.get("verdict") == "pass" and r.get("reverse_ok") is True}
    added = [u for u in umap.get(cand["sha"], {}).get("added", []) if base.get(u) == "pass"]
    failing = r.get("failing", [])
    out["failing"] = failing
    out["failing_fix_added"] = [u for u in failing if u in added]
    t = triage(cand["sha"])
    out["label"] = t.get("label"); out["symptom"] = t.get("symptom"); out["subsystem"] = t.get("subsystem")
    inj = ""
    for d in (f"{common.RESULTS}/{tier}/{cand['sha']}",):
        p = os.path.join(d, "injection.patch")
        if os.path.exists(p):
            inj = open(p, errors="replace").read()
    out["injection_files"] = patch_files(inj)
    out["locality"] = locality(out["injection_files"], cand["impl"])
    reasons = []
    if not out["gate"]:
        reasons.append("gate")
    if not out["failing_fix_added"]:
        reasons.append("no failing fix-added case (fix-modified file only)")
    if out["label"] != "bug":
        reasons.append(f"triage: {out['label']}")
    if tier == "adapted":
        a = anchor_of(cand["sha"])
        out["anchor"] = None if a is None else {"status": a.get("status"), "failing": a.get("anchor_failing", [])}
        if not (a and a.get("exact") and set(a.get("anchor_failing", [])) & set(failing)):
            reasons.append("anchor not exact" if a else "anchor missing")
    out["strict"] = not reasons
    out["not_strict_because"] = reasons
    out["repro"] = bool(r.get("repro"))
    out["repro_method"] = (r.get("repro") or {}).get("method")
    return out
