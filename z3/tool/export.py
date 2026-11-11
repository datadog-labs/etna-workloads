#!/usr/bin/env python3
"""Export the dataset: one directory per gated bug + Marauders patches + bin scripts.
Usage: export.py OUTDIR"""
import os, sys, json, re, shutil, collections, datetime, subprocess
sys.path.insert(0, os.path.dirname(__file__))
from common import *

D = DATA
RELEASE_SHA = "430d19e697e2ec9bad79ff210d41b4a7a5fcfa3e"
Z3TEST_SHA = "aff10a93980481ae9928c0f6d95dfbc2f561fdbf"


def load_dir(d):
    p = os.path.join(D, d)
    out = {}
    if os.path.isdir(p):
        for f in os.listdir(p):
            if f.endswith(".json") and not f.endswith(".sonnet.json"):
                r = json.load(open(os.path.join(p, f)))
                out[r["sha"]] = r
    return out


def hunks(patch):
    """[(file, old_start, old_len)] of a unified diff."""
    out, cur = [], None
    for l in patch.splitlines():
        if l.startswith("--- "):
            cur = l[4:].split("\t")[0]
            cur = cur[2:] if cur.startswith("a/") else cur
        m = re.match(r"@@ -(\d+)(?:,(\d+))? ", l)
        if m and cur:
            out.append((cur, int(m.group(1)), int(m.group(2) or 1)))
    return out


def locality(inj_files, fix_files):
    a, b = set(inj_files), set(fix_files)
    if a <= b:
        return "same-files"
    if a & b:
        return "overlapping-files"
    if {os.path.dirname(f) for f in a} & {os.path.dirname(f) for f in b}:
        return "same-dirs"
    return "disjoint"


def slug(s):
    s = re.sub(r"[^a-z0-9]+", "_", (s or "misc").lower()).strip("_")
    return s[:24] or "misc"


def main():
    outdir = sys.argv[1]
    cands = {}
    for f, pool in (("candidates.json", "inrepo"), ("candidates_z3test.json", "z3test")):
        for c in json.load(open(os.path.join(D, f))):
            c["pool"] = pool
            cands[c["sha"]] = c
    tri, verb, adap, anch, rep = (load_dir(x) for x in ("triage", "verbatim", "adapted", "anchor", "repro"))
    hand = json.load(open(os.path.join(D, "hand_labels.json"))) if os.path.exists(os.path.join(D, "hand_labels.json")) else {}
    bugs = []
    for sha, c in cands.items():
        r = None
        if verb.get(sha, {}).get("status") == "pass_gate":
            r = verb[sha]
        elif adap.get(sha, {}).get("status") == "pass_gate":
            r = adap[sha]
        if r:
            bugs.append((c, r))
    bugs.sort(key=lambda x: -x[0]["time"])
    for sub in ("bugs", "patches"):
        shutil.rmtree(os.path.join(outdir, sub), ignore_errors=True)
        os.makedirs(os.path.join(outdir, sub))
    index = []
    for c, r in bugs:
        sha = c["sha"]
        t = tri.get(sha, {})
        tier = r["tier"]
        a = anch.get(sha, {})
        anchor = "n/a (verbatim)" if tier == "verbatim" else a.get("anchor", "not-run")
        if anchor == "none" and not any(all(x["status"] == "pass" for x in rs) for rs in a.get("at_fix", {}).values()):
            anchor = "oracle_fails_at_fix"      # inconclusive: the oracle does not pass even with the fix
        if anchor == "build_fails" and a.get("cmake_min_lowered_to_3_28") and a.get("build_fix") != "ok":
            anchor = "toolchain_cmake"          # host CMake 3.28 too old for this revision
        fix_added_fail = sorted(set(r["failing"]) & set(c.get("fix_added_units", [])))
        hl = hand.get(sha)
        strict = (c["pool"] == "inrepo" and bool(fix_added_fail) and t.get("label") == "bug" and not hl
                  and (tier == "verbatim" or anchor == "exact"))
        name = slug(t.get("subsystem"))
        bid = sha[:8]
        bname = f"{name}_{bid}"
        bdir = os.path.join(outdir, "bugs", bname)
        os.makedirs(bdir)
        open(os.path.join(bdir, "injection.patch"), "w").write(r["injection"])
        open(os.path.join(outdir, "patches", f"{bname}.patch"), "w").write(r["injection"])
        inj_files = sorted({h[0] for h in hunks(r["injection"])})
        issues = c.get("issues", [])
        links = [f"https://github.com/Z3Prover/z3/issues/{i}" for i in issues]
        if c.get("pr"):
            links.append(f"https://github.com/Z3Prover/z3/pull/{c['pr']}")
        links.append(f"https://github.com/Z3Prover/z3/commit/{sha}")
        rp = rep.get(sha, {})
        has_repro = rp.get("status") == "verified"
        meta = dict(
            name=bname, fix_commit=sha,
            fix_date=datetime.datetime.fromtimestamp(c["time"], datetime.timezone.utc).strftime("%Y-%m-%d"),
            fix_subject=c["subject"], report_links=links, pool=c["pool"], tier=tier,
            verbatim_apply=r.get("apply") if tier == "verbatim" else None,
            labels=dict(triage=t.get("label"), symptom=t.get("symptom"), subsystem=t.get("subsystem"),
                        confidence=t.get("confidence"), triage_model="claude-haiku-5-5",
                        hand_label=hl),
            strict=strict,
            failing_cases=r["failing"], failing_cases_added_by_fix=fix_added_fail,
            injection_files=inj_files, fix_impl_files=c["impl"],
            locality=locality(inj_files, c["impl"]),
            anchor=anchor, anchor_failing=a.get("reversed_failing"),
            agent_model=r.get("model") if tier == "adapted" else None,
            reproducer=bool(has_repro),
            release="z3-5.3.3", release_commit=RELEASE_SHA,
            z3test_commit=Z3TEST_SHA if c["pool"] == "z3test" else None,
        )
        json.dump(meta, open(os.path.join(bdir, "meta.json"), "w"), indent=1)
        oracle = dict(runner="test-z3 <unit> (pass = exit 0 and a 'PASS' line); z3test:<file> = "
                             "z3 model_validate=true <file> must print <file>.expected.out",
                      cases=r["oracle"], failing=r["failing"],
                      base_runs="all oracle cases passed twice on the clean release build",
                      injected_runs={u: [x["status"] + (":" + x["detail"] if x["detail"] else "") for x in r["results"][u]]
                                     for u in r["oracle"]})
        json.dump(oracle, open(os.path.join(bdir, "oracle.json"), "w"), indent=1)
        for u in r["oracle"]:
            if u.startswith("z3test:"):
                rel = u[len("z3test:"):]
                src = os.path.join(WORK, "z3test-pinned", "regressions", rel)
                dst = os.path.join(bdir, "z3test", rel)
                os.makedirs(os.path.dirname(dst), exist_ok=True)
                shutil.copyfile(src, dst)
                shutil.copyfile(src[:-5] + ".expected.out", dst[:-5] + ".expected.out")
        if has_repro:
            shutil.copy(os.path.join(D, "repro", sha + ".smt2"), os.path.join(bdir, "repro.smt2"))
            v = rp["verify"]
            sh_rc = lambda x: (128 - x) if isinstance(x, int) and x < 0 else x  # shell-style exit codes
            open(os.path.join(bdir, "repro.expected.clean"), "w").write(v["clean_out"] + f"exit={sh_rc(v['clean_rc'])}\n")
            open(os.path.join(bdir, "repro.expected.buggy"), "w").write(v["bug_out"] + f"exit={sh_rc(v['bug_rc'][0])}\n")
        rat = r.get("rationale") if tier == "adapted" else None
        if rat:  # agents quote absolute paths of their work trees: normalize
            rat = re.sub(r"/[^\s`'\"]*?/(slots/s\d+|base|anchor)/src/", "<z3-src>/", rat)
        open(os.path.join(bdir, "RATIONALE.md"), "w").write(
            rat if rat else f"# {bname}\n\nVerbatim tier: `injection.patch` is the reverse of the implementation "
                            f"hunks of upstream fix {sha} (\"{c['subject']}\"), applied to z3-5.3.3"
                            f" ({r.get('apply')}).\n")
        index.append(meta)
    json.dump(index, open(os.path.join(outdir, "bugs.json"), "w"), indent=1)
    print(len(index), "bugs exported;", sum(m["strict"] for m in index), "strict")


if __name__ == "__main__":
    main()
