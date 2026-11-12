#!/usr/bin/env python3
"""Export gated bugs as an etna-style workload directory.

workload/bugs/<name>_<id>/  injection.patch, meta.json, oracle.json, RATIONALE.md,
                            repro.sql + repro.clean.out/.status + repro.injected.out/.status (when a reproducer exists)
workload/patches/<name>_<id>.patch   (Marauders)
workload/marauder.toml, workload/bugs.csv
Strict and looser bugs are both exported; meta.json["strict"] and ["not_strict_because"] say which is which.
usage: export.py OUT_DIR
"""
import csv, json, os, re, shutil, sys, time
import common, classify

OUT = os.path.abspath(sys.argv[1]) if len(sys.argv) > 1 else None
STOP = {"fix", "fixes", "fixed", "the", "a", "an", "of", "in", "for", "to", "and", "when", "with", "on", "issue", "is"}


def slug(subject):
    s = re.sub(r"#\d+|\(.*?\)|\[.*?\]", " ", subject.lower())
    words = [w for w in re.findall(r"[a-z0-9]+", s) if w not in STOP]
    return "_".join(words[:5]) or "bug"


LOCAL_RE = re.compile(r"(/[\w.-]+)*/duckdb-etna-work/(slots/[^/\s]+/src|pristine|runtmp/[^\s:]*)/?")


def scrub(text):
    """Remove machine-local paths (build slots, scratch, home) from text that goes into the dataset."""
    text = re.sub(r"\S*?(?:\.\./)+(test/|src/)", r"\1", text or "")   # <build>/test/x/../../../../test/ -> test/
    text = LOCAL_RE.sub("", text)
    text = text.replace(common.WORK, "<WORK>").replace(common.HOME, "<HOME>")
    return re.sub(r"/home/\S*", "<path>", text)  # catches fragments cut by truncation


def links(c):
    out = [f"https://github.com/duckdb/duckdb/commit/{c['sha']}"]
    if c.get("pr"):
        out.append(f"https://github.com/duckdb/duckdb/pull/{c['pr']}")
    out += [f"https://github.com/duckdb/duckdb/issues/{n}" for n in c.get("issues", [])]
    return out


def main():
    cands = {c["sha"]: c for c in common.candidates()}
    um = common.units_map(); base = common.base_oracle()
    bugs_dir = os.path.join(OUT, "bugs"); pat_dir = os.path.join(OUT, "patches")
    for d in (bugs_dir, pat_dir):
        shutil.rmtree(d, ignore_errors=True); os.makedirs(d)
    rows = []
    for tier in ("verbatim", "adapted"):
        tdir = os.path.join(common.RESULTS, tier)
        if not os.path.isdir(tdir):
            continue
        for sha in sorted(os.listdir(tdir)):
            rp = os.path.join(tdir, sha, "result.json")
            if not os.path.exists(rp) or sha not in cands:
                continue
            r = json.load(open(rp)); c = cands[sha]
            cl = classify.classify(tier, r, c, um, base)
            if not cl["gate"]:
                continue
            name = f"{slug(c['subject'])}_{sha[:10]}"
            bd = os.path.join(bugs_dir, name); os.makedirs(bd)
            shutil.copy(os.path.join(tdir, sha, "injection.patch"), os.path.join(bd, "injection.patch"))
            shutil.copy(os.path.join(tdir, sha, "injection.patch"), os.path.join(pat_dir, name + ".patch"))
            t = classify.triage(sha)
            meta = {
                "id": name, "fix_commit": sha, "fix_parent": c["parent"],
                "fix_date": time.strftime("%Y-%m-%d", time.gmtime(c["time"])), "fix_subject": c["subject"],
                "pr_title": c.get("pr_title"), "links": links(c), "internal_refs": c.get("internal", []),
                "fix_signal": c["signal"], "tier": tier,
                "apply": r.get("apply") if tier == "verbatim" else "adapted",
                "labels": {"triage": t.get("label"), "symptom": t.get("symptom"), "subsystem": t.get("subsystem"),
                           "confidence": t.get("confidence"), "summary": t.get("summary"), "model": t.get("model")},
                "strict": cl["strict"], "not_strict_because": cl["not_strict_because"],
                "locality": cl["locality"], "injection_files": cl["injection_files"], "fix_impl_files": c["impl"],
                "fix_test_files": c["tests"], "anchor": cl.get("anchor"),
                "reproducer": cl["repro_method"],
                "agent": ({"model": r.get("model"), "cost_usd": r.get("agent", {}).get("cost"), "retry_of": r.get("retry_of")}
                          if tier == "adapted" else None),
                "release": common.RELEASE,
            }
            common.write_json(os.path.join(bd, "meta.json"), meta)
            common.write_json(os.path.join(bd, "oracle.json"), {
                "runner": "build/relassert/test/unittest", "granularity": "sqllogictest file / Catch TEST_CASE",
                "oracle": r["oracle"], "failing": cl["failing"], "failing_fix_added": cl["failing_fix_added"],
                "base_runs": 2, "injected_runs": 2,
                "failure_details": {u: scrub(scrub(r["runs"][0][u][1])[:2000]) for u in cl["failing"]}})
            src_rat = os.path.join(tdir, sha, "RATIONALE.md")
            if tier == "adapted" and os.path.exists(src_rat):
                open(os.path.join(bd, "RATIONALE.md"), "w").write(scrub(open(src_rat, errors="replace").read()))
            else:
                open(os.path.join(bd, "RATIONALE.md"), "w").write(
                    f"# {name}\n\nVerbatim tier: `injection.patch` is the reverse of the implementation (src/) hunks of "
                    f"upstream commit {sha} (\"{c['subject']}\"), applied to DuckDB {common.RELEASE} "
                    f"({r.get('apply')}). No hunk was written by hand or by an agent.\n\n"
                    f"Failing oracle cases (failed in both injected runs, passed in both base runs):\n" +
                    "".join(f"- {u}\n" for u in cl["failing"]))
            rep = r.get("repro")
            if rep:
                open(os.path.join(bd, "repro.sql"), "w").write(rep["sql"])
                open(os.path.join(bd, "repro.clean.out"), "w").write(rep["clean_out"])  # already <ROOT>/<TMP>-normalised
                open(os.path.join(bd, "repro.clean.status"), "w").write(str(rep["clean_status"]) + "\n")
                open(os.path.join(bd, "repro.injected.out"), "w").write(rep["injected_out"])
                open(os.path.join(bd, "repro.injected.status"), "w").write(str(rep["injected_status"]) + "\n")
            rows.append({"id": name, "tier": tier, "strict": cl["strict"], "fix_commit": sha, "fix_date": meta["fix_date"],
                         "symptom": t.get("symptom"), "subsystem": t.get("subsystem"), "locality": cl["locality"],
                         "reproducer": cl["repro_method"] or "", "anchor": (cl.get("anchor") or {}).get("status", "")})
    with open(os.path.join(OUT, "bugs.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()) if rows else ["id"]); w.writeheader(); w.writerows(rows)
    with open(os.path.join(OUT, "marauder.toml"), "w") as f:
        f.write("# Marauders project config: the bugs are standalone patches under patches/\n"
                "# (one variation per file, activated with `git apply` at the DuckDB v2.0.0 checkout root).\n"
                "languages = []\nignore = []\nuse_gitignore = false\ncustom_languages = []\n")
    print(len(rows), "bugs exported;", sum(r["strict"] for r in rows), "strict")


if __name__ == "__main__":
    main()
