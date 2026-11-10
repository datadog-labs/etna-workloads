#!/usr/bin/env python3
"""Export every gate-passing bug into the workload directory.

Usage: export.py OUT_DIR
Strict = gate pass, a failing case the fix itself added, triage label 'bug', for
adapted bugs an exact anchor, and no untraced hunk found in review.
"""
import glob, json, os, re, shutil, subprocess, sys

W = os.path.expanduser("~/ts-etna-work")
TOOLS = os.path.dirname(os.path.abspath(__file__))
EXPORT_SRC = os.path.join(os.path.dirname(TOOLS), "export")
ROOT_JUNK = {"out", "outDir", "built", ".tmp", ".claude"}  # left behind by agents at the repro root
UNTRACED = {"5b10466b6355"}  # hand review: supporting hunk not from the fix (see reports)


def slug(s, n=40):
    s = re.sub(r"\(#\d+\)\s*$", "", s)
    s = re.sub(r"^(fix(es|ed)?|🤖 pick pr #\d+)\s*[:(]?\s*(\d+\)?:?)?\s*", "", s, flags=re.I)
    s = re.sub(r"[^a-z0-9]+", "_", s.lower()).strip("_")
    return (s[:n].rstrip("_") or "bug")


def load(p):
    return json.load(open(p)) if os.path.exists(p) else None


def main(out):
    cands = {c["sha"][:12]: c for c in map(json.loads, open(f"{W}/candidates.jsonl"))}
    tri = {json.loads(l)["sha"][:12]: json.loads(l) for l in open(f"{W}/triage.jsonl")}
    bugs_dir = os.path.join(out, "bugs")
    patches_dir = os.path.join(out, "patches")
    for d in (bugs_dir, patches_dir):
        shutil.rmtree(d, ignore_errors=True)
        os.makedirs(d)
    rows, stripped = [], []
    for s12, c in sorted(cands.items(), key=lambda kv: -kv[1]["time"]):
        src = None
        for stage in ("verbatim", "adapted", "adapted-retry"):
            r = load(f"{W}/{stage}/{s12}/result.json")
            if r and r["status"] == "gate_pass":
                src = (stage, f"{W}/{stage}/{s12}", r)
                break
        if not src:
            continue
        stage, d, r = src
        tier = "verbatim" if stage == "verbatim" else "adapted"
        t = tri.get(s12, {})
        an = load(f"{d}/anchor.json") if tier == "adapted" else None
        fix_files, inj_files = set(c["impl_files"]), set(r["files"])
        locality = "same" if inj_files <= fix_files else ("overlap" if inj_files & fix_files else "disjoint")
        reasons = []
        if not r.get("failing_added"):
            reasons.append("no failing case added by the fix")
        if t.get("label") != "bug":
            reasons.append(f"triage label {t.get('label')}")
        if tier == "adapted" and (an or {}).get("status") != "exact":
            reasons.append(f"anchor {(an or {}).get('status')}")
        if s12 in UNTRACED:
            reasons.append("untraced hunk (hand review)")
        rep = load(f"{d}/repro_result.json")
        has_repro = bool(rep and rep.get("status") == "verified")
        name = f"{slug(c['subject'])}_{c['sha'][:8]}"
        bd = os.path.join(bugs_dir, name)
        os.makedirs(bd)
        shutil.copy(f"{d}/injection.patch", bd)
        shutil.copy(f"{d}/injection.patch", os.path.join(patches_dir, f"{name}.patch"))
        oracle = load(f"{d}/oracle.json")
        json.dump(oracle, open(f"{bd}/oracle.json", "w"), indent=1, sort_keys=True)
        if has_repro:
            # Drop compiler outputs an agent left behind (inputs such as fake node_modules stay).
            root = os.path.abspath(f"{d}/repro")
            shutil.copytree(root, f"{bd}/repro",
                            ignore=lambda dp, names: [n for n in names if os.path.abspath(dp) == root and n in ROOT_JUNK])
            if any(n in ROOT_JUNK for n in os.listdir(root)):
                stripped.append(bd)
        if tier == "adapted" and os.path.exists(f"{d}/RATIONALE.md"):
            txt = open(f"{d}/RATIONALE.md").read()
            txt = re.sub(re.escape(W) + r"/agents/[^/\s]+/[^/\s]+/", "<workdir>/", txt).replace(W, "<work>")
            open(f"{bd}/RATIONALE.md", "w").write(txt)
        else:
            open(f"{bd}/RATIONALE.md", "w").write(
                f"# Rationale\n\nVerbatim tier: `injection.patch` is the reverse of the implementation hunks of upstream "
                f"commit {c['sha']} (\"{c['subject']}\"), applied to v6.0.3 "
                f"({'exactly' if r['apply']['method'] == 'git-apply' else 'with fuzz (GNU patch -F3); changed lines are identical to the fix'}).\n")
        pr = c.get("pr") or c.get("pick_of")
        meta = {
            "name": name,
            "fix_commit": c["sha"],
            "fix_date": subprocess.run(["git", "-C", f"{W}/ts", "show", "-s", "--format=%cI", c["sha"]],
                                       capture_output=True, text=True).stdout.strip(),
            "subject": c["subject"],
            "links": ([f"https://github.com/microsoft/TypeScript/pull/{pr}"] if pr else []) +
                     [f"https://github.com/microsoft/TypeScript/issues/{i}" for i in c["issues"] if i != pr][:5],
            "tier": tier,
            "apply_method": r["apply"]["method"],
            "strict": not reasons,
            "not_strict_reasons": reasons,
            "triage": {k: t.get(k) for k in ("label", "symptom", "subsystem", "confidence", "reason", "model")},
            "files": r["files"],
            "fix_files": c["impl_files"],
            "locality": locality,
            "anchor": ({k: an.get(k) for k in ("status", "anchor_cases", "anchor_keys")} if an else None),
            "failing_cases": r["failing"],
            "failing_cases_added_by_fix": r["failing_added"],
            "oracle_cases": len(oracle),
            "test_kinds": sorted({o["runner"] for o in oracle.values()}),
            "reproducer": ({"verified": True, **{k: rep["check"].get(k) for k in ("exit_differs", "output_differs")}}
                           if has_repro else None),
            "agent_model": (r.get("agent") or {}) and ("claude-opus" if stage == "adapted-retry" else "claude-sonnet"),
        }
        json.dump(meta, open(f"{bd}/meta.json", "w"), indent=1)
        rows.append(meta)
    # Static parts: bin/, licence files, README template.
    shutil.rmtree(os.path.join(out, "bin"), ignore_errors=True)
    shutil.copytree(os.path.join(EXPORT_SRC, "bin"), os.path.join(out, "bin"))
    shutil.copy(os.path.join(TOOLS, "jsonl-reporter.cjs"), os.path.join(out, "bin"))
    for f in ("LICENSE", "NOTICE", "LICENSE-3rdparty.csv"):
        shutil.copy(os.path.join(EXPORT_SRC, f), out)
    with open(os.path.join(out, "marauder.toml"), "w") as f:
        f.write('# Marauders workload: TypeScript compiler v6.0.3, historical bugs as patches.\n'
                'name = "typescript"\nlanguage = "typescript"\ncustom_languages = []\n'
                'source = "https://github.com/microsoft/TypeScript.git"\nrevision = "v6.0.3"\n'
                'patches = "patches"\n')
    json.dump([{k: m[k] for k in ("name", "tier", "strict", "fix_commit", "subject", "locality")} |
               {"symptom": m["triage"]["symptom"], "subsystem": m["triage"]["subsystem"],
                "year": m["fix_date"][:4], "reproducer": bool(m["reproducer"])} for m in rows],
              open(os.path.join(out, "bugs.json"), "w"), indent=1)
    open(os.path.join(W, "export_stripped.txt"), "w").write("\n".join(stripped))
    print(len(stripped), "reproducers stripped of root junk (re-verify these);", end=" ")
    print(len(rows), "bugs;", sum(m["strict"] for m in rows), "strict")


if __name__ == "__main__":
    main(sys.argv[1])
