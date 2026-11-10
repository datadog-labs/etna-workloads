#!/usr/bin/env python3
"""Classify gated bugs (strict / loose) and export the workload directory.

Strict (headline) = gate pass, a failing case was added by the fix itself, triage label
"bug", and for adapted bugs an exact anchor; timeout-only failures must have been
confirmed by the quiet recheck.  Everything else that passed the gate is exported too,
labelled loose with the reasons.
"""
import argparse, json, os, re, shutil, subprocess, sys
import trace as tracemod

REPO = os.path.expanduser("~/node-etna-work/node")


def slug(subject):
    m = re.match(r"^([\w./-]+?)(?:,[\w ./-]+)?:", subject)
    s = m.group(1) if m else "node"
    return re.sub(r"[^a-z0-9]+", "-", s.lower()).strip("-") or "node"


_HOME = re.escape(os.path.expanduser("~"))
LOCAL = [(re.compile(_HOME + r"/node-etna-work/slots/[a-z0-9]+"), "<node-checkout>"),
         (re.compile(_HOME + r"/node-etna-work/(?:scratch|tmp)/[^\s'\")`]*"), "<scratch>"),
         (re.compile(_HOME + r"/node-etna-work/[^\s'\")`]*"), "<work>"),
         (re.compile(_HOME + r"\b"), "<home>")]


def sanitize(text):
    """Machine-local paths in agent-written notes/scripts -> placeholders."""
    for rx, rep in LOCAL:
        text = rx.sub(rep, text)
    return text


def standalone(repro):
    return sanitize(repro.get("script_text", "")) == repro.get("script_text", "")


def anchor_meta(an):
    """Anchor outcome with an honest reason for build failures of old revisions."""
    if not an:
        return {"anchor": "not run yet"}
    m = {k: an.get(k) for k in ("anchor", "failing_at_parent", "passing_at_fix", "build_s")}
    tail = an.get("log_tail") or ""
    if an["anchor"] == "configure-needs-python2":
        m["anchor"] = "anchor build failed"
        m["reason"] = "configure needs Python 2 (no Python 2 on the host)"
    elif an["anchor"] == "configure-fails":
        m["anchor"] = "anchor build failed"
        if "distutils" in tail:
            m["reason"] = ("configure needs Python <= 3.10 (distutils was removed in 3.12; "
                           "old gyp also opens files with mode 'rU'); no such Python on the host")
        elif any(x in tail for x in ("leading zeros", "Missing parentheses", "multiple exception types",
                                       "Please use either Python 2")):
            m["reason"] = "configure needs Python 2"
        else:
            m["reason"] = "configure failed"
    elif an["anchor"].startswith("build-fails") or an["anchor"] == "parent-build-fails":
        m["reason"] = an["anchor"]
        m["anchor"] = "anchor build failed"
    return m


def load(path):
    if not path or not os.path.exists(path):
        return {}
    out = {}
    for l in open(path):
        r = json.loads(l)
        out[r["sha"]] = r
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--data", default=os.path.expanduser("~/node-etna/data"))
    ap.add_argument("--out", required=True)
    a = ap.parse_args()
    D = a.data
    cands = load(f"{D}/candidates_units.jsonl")
    tri = load(f"{D}/triage.jsonl")
    ver = load(f"{D}/verbatim.jsonl")
    ada = load(f"{D}/adapted.jsonl")
    ada.update({k: v for k, v in load(f"{D}/adapted_retry.jsonl").items() if v["status"] == "pass"})
    anc = load(f"{D}/anchors.jsonl")
    rep = load(f"{D}/repro.jsonl")
    rechk = load(f"{D}/recheck.jsonl")
    base = json.load(open(f"{D}/base_runs.json"))["runs"]

    bugs = []
    for sha, r in ver.items():
        if r["status"] == "pass":
            bugs.append(dict(sha=sha, tier="verbatim", injection=r["injection"], failing=r["failing"],
                             added=r.get("added_failing", []), oracle=r["oracle"],
                             inj_runs=r.get("inj_runs"), apply=r.get("apply"), locality="same-files",
                             rationale=None, anchor=None))
    for sha, r in ada.items():
        if r["status"] == "pass" and sha not in {b["sha"] for b in bugs}:
            g = r["gate"]
            bugs.append(dict(sha=sha, tier="adapted", injection=g["injection"], failing=g["failing"],
                             added=g.get("added_failing", []), oracle=g["oracle"], inj_runs=g.get("inj_runs"),
                             apply=None, locality=r.get("locality"), rationale=r.get("rationale"),
                             anchor=anc.get(sha), agent=r.get("agent")))
    os.makedirs(a.out, exist_ok=True)
    bdir = os.path.join(a.out, "bugs")
    pdir = os.path.join(a.out, "patches")
    for d in (bdir, pdir):
        shutil.rmtree(d, ignore_errors=True)
        os.makedirs(d)
    summary = []
    for b in sorted(bugs, key=lambda b: cands[b["sha"]]["date"], reverse=True):
        c, t = cands[b["sha"]], tri.get(b["sha"], {})
        reasons = []
        if not b["added"]:
            reasons.append("no failing case was added by the fix")
        if t.get("label") != "bug":
            reasons.append(f"triage label {t.get('label')}")
        if b["tier"] == "adapted":
            an = anchor_meta(b["anchor"])["anchor"]
            if an != "exact":
                am = anchor_meta(b["anchor"])
                reasons.append(f"anchor: {an}" + (f" ({am['reason']})" if am.get("reason") else ""))
        # failures that are only timeouts must be confirmed by the quiet recheck
        stat = {cs: [run.get(cs) for run in (b["inj_runs"] or [])] for cs in b["failing"]}
        if all(all(s == "timeout" for s in v) for v in stat.values()):
            rc = rechk.get(b["sha"])
            if not rc or not rc.get("confirmed"):
                reasons.append("timeout-only failure not confirmed by quiet recheck")
        strict = not reasons
        bid = f"{slug(c['subject'])}_{b['sha'][:12]}"
        d = os.path.join(bdir, bid)
        os.makedirs(d)
        open(os.path.join(d, "injection.patch"), "w").write(b["injection"])
        shutil.copy(os.path.join(d, "injection.patch"), os.path.join(pdir, f"{bid}.patch"))
        inj_files = sorted(set(re.findall(r"^\+\+\+ b/(\S+)", b["injection"], re.M)) |
                           set(re.findall(r"^--- a/(\S+)", b["injection"], re.M)))
        repro = rep.get(b["sha"])
        m = {
            "id": bid,
            "fix": {"commit": b["sha"], "date": c["date"], "subject": c["subject"],
                    "pr_url": c.get("pr_url"), "report_links": c.get("links", []),
                    "cve": c.get("cve", []), "signals": c["signals"],
                    "url": f"https://github.com/nodejs/node/commit/{b['sha']}",
                    "impl_files": c["impl_files"], "test_files": c["test_files"]},
            "tier": b["tier"],
            "strict": strict,
            "not_strict_reasons": reasons,
            "labels": {k: t.get(k) for k in ("label", "symptom", "subsystem", "confidence")},
            "triage_model": t.get("model"),
            "locality": b["locality"],
            "id_trace": (1.0 if b["tier"] == "verbatim" else
                         tracemod.token_trace(b["sha"], b["injection"], c["impl_files"])),
            "injected_files": inj_files,
            "apply": b["apply"],
            "anchor": None if b["tier"] == "verbatim" else anchor_meta(b["anchor"]),
            "failing_cases": b["failing"],
            "fix_added_failing_cases": b["added"],
            "reproducer": ({"file": repro["script"], "verified": True}
                           if repro and repro.get("status") == "verified" and standalone(repro) else None),
            "reproducer_note": ("rejected: reads files from a local Node.js checkout (not standalone)"
                                if repro and repro.get("status") == "verified" and not standalone(repro) else None),
            "release": "v26.13.0",
            "build": "./configure --debug-node",
        }
        json.dump(m, open(os.path.join(d, "meta.json"), "w"), indent=2)
        json.dump({"runner": "tools/test.py (TAP), one case per test file (wpt: per sub-test); "
                             "cctest: one case per gtest TEST, one process per case",
                   "oracle_cases": b["oracle"],
                   "base_runs": {cs: base.get(cs) for cs in b["oracle"]},
                   "failing_cases": b["failing"],
                   "fix_added_failing_cases": b["added"],
                   "injected_runs": b["inj_runs"]},
                  open(os.path.join(d, "oracle.json"), "w"), indent=1)
        if b["rationale"]:
            open(os.path.join(d, "RATIONALE.md"), "w").write(sanitize(b["rationale"]))
        else:
            open(os.path.join(d, "RATIONALE.md"), "w").write(
                f"# {c['subject']}\n\nVerbatim tier: the injection is the reverse of the implementation "
                f"hunks of upstream commit {b['sha']} applied to v26.13.0 ({b['apply']}).\n\n"
                f"Upstream commit message:\n\n```\n{c['body']}\n```\n")
        if m["reproducer"]:
            open(os.path.join(d, repro["script"]), "w").write(repro["script_text"])
        summary.append(m)
    json.dump(summary, open(os.path.join(a.out, "bugs.json"), "w"), indent=1)
    print(f"exported {len(summary)} bugs; strict {sum(m['strict'] for m in summary)}")


if __name__ == "__main__":
    main()
