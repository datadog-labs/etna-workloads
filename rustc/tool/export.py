#!/usr/bin/env python3
"""Export the workload directory: one directory per gate-passing bug, Marauders
patches, marauder.toml, bin/ scripts, licensing files, summary CSV.

usage: export.py [--out ~/rustc-etna/workload/rustc]
"""
import argparse
import collections
import csv
import json
import os
import re
import shutil
import sys

sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, ROOT, WORK, RELEASE, git  # noqa: E402

HOME = os.path.expanduser("~")
PATH_SUBS = [(os.path.join(WORK, "slots") + "/s", "<TREE>#"), (WORK + "/agents/", "<AGENTDIR>/"),
             (WORK, "<WORK>"), (ROOT, "<TOOLS>"), (HOME, "<HOME>")]


def scrub(text):
    text = re.sub(re.escape(os.path.join(WORK, "slots")) + r"/s\d+", "<TREE>", text)
    text = re.sub(re.escape(WORK) + r"/agents/[^/\s]+", "<AGENTDIR>", text)
    for a, b in ((WORK, "<WORK>"), (ROOT, "<TOOLS>"), (HOME, "<HOME>")):
        text = text.replace(a, b)
    return text


# Files a compiler leaves in a reproducer directory when an agent ran it in place (ICE dumps
# with machine paths, build outputs of the injected compiler, incremental caches): never
# reproducer inputs (no repro.sh uses one without building it first; checked on all 63 dirs).
REPRO_JUNK = re.compile(r"^rustc-ice-.*\.txt$|\.long-type-\d+\.txt$|\.(rlib|rmeta|ll|s|mir|bin|o|d|so|a|dylib)$"
                        r"|^(main|out|out\.txt)$")


def repro_junk(src, names):
    """Generated files to leave out, except a file that a Rust input includes by name (an
    assembly file pulled in by include_str! from main.rs).  Files repro.sh names are its own
    outputs (it rebuilds them; every reproducer reproduces without them)."""
    refs = ""
    for n in names:
        if n.endswith(".rs"):
            refs += open(os.path.join(src, n), errors="surrogateescape").read()
    out = []
    for n in names:
        p = os.path.join(src, n)
        if os.path.isdir(p) or os.access(p, os.X_OK) and not n.endswith(".sh"):
            out.append(n)
        elif REPRO_JUNK.search(n) and (n not in refs or n.startswith("rustc-ice-")):
            out.append(n)
    return out


# Harness-verified reproducers that do not reproduce from the exported copy with the clean
# compiler (bin/run_repro.py over all reproducers): not exported; the bug keeps its tests.
REPRO_DROPPED = {
    "a9235505d663758ec737ac95b75f2f7b483efe32":
        "recorded output depended on a stale libminicore.rmeta left in the agent's directory: "
        "the script's own build of it is killed by SIGPIPE (`| head -5`) before it writes the file",
    "09960e03194626738b3533b6c2d06a0c505117d3":
        "output (-Z meta-stats percentages) depends on the length of the directory it runs in",
}


def load_dir(d):
    out = {}
    if os.path.isdir(d):
        for f in os.listdir(d):
            if f.endswith(".json"):
                out[f[:-5]] = json.load(open(os.path.join(d, f)))
    return out


def injected_files(patch):
    return sorted({line[6:] for line in patch.splitlines() if line.startswith("+++ b/")})


def bugs():
    cands = {json.loads(line)["commit"]: json.loads(line) for line in open(os.path.join(DATA, "candidates.jsonl"))}
    orcs = json.load(open(os.path.join(DATA, "oracles.json")))
    tri = load_dir(os.path.join(DATA, "triage"))
    verb = load_dir(os.path.join(DATA, "verbatim"))
    adap = load_dir(os.path.join(DATA, "adapted"))
    anch = load_dir(os.path.join(DATA, "anchor"))
    rep = load_dir(os.path.join(DATA, "repro"))
    out = []
    for h, c in cands.items():
        v, a = verb.get(h), adap.get(h)
        if v and v["status"] == "gate_pass":
            tier, g = "verbatim", v
            patch = open(os.path.join(DATA, "verbatim", "patches", h + ".patch")).read()
            locality = "same-files"
        elif a and a["status"] == "gate_pass":
            tier, g = "adapted", a["gate"]
            patch = open(os.path.join(DATA, "adapted", "patches", h + ".patch")).read()
            locality = a.get("locality")
        else:
            continue
        t = tri.get(h, {})
        an = anch.get(h) if tier == "adapted" else None
        reasons = []
        if not g.get("failing_added_by_fix"):
            reasons.append("no failing case added by the fix")
        if t.get("label") != "bug":
            reasons.append(f"triage label {t.get('label')}")
        if tier == "adapted" and (not an or an.get("status") != "exact"):
            reasons.append(f"anchor {an.get('status') if an else 'not run'}")
        out.append(dict(commit=h, c=c, tier=tier, gate=g, patch=patch, locality=locality,
                        triage=t, anchor=an, strict=not reasons, loose_reasons=reasons,
                        repro=rep.get(h), oracle=orcs[h], adapted=a))
    return out


def name_for(b, used):
    crate = injected_files(b["patch"])[0].split("/")[1]
    base = f"{crate}_{b['c'].get('pr')}"
    n, k = base, 1
    while n in used:
        k += 1
        n = f"{base}-{k}"
    used.add(n)
    return n


UPSTREAM = os.path.join(WORK, "probe-1.99.1")  # pristine 1.99.1 checkout (licence texts)

DERIVED = """Material derived from the Rust project: the injection patches (bugs/*/injection.patch,
patches/), which are diffs of rustc's compiler sources; the reproducer inputs
(bugs/*/reproducer/*.rs and other input files), which are copied or adapted from the
Rust test suite; the compiler outputs recorded for them
(bugs/*/reproducer/expected_*.txt), which quote those inputs; and the rustc test
names, code excerpts and commit messages quoted in oracle.json, meta.json and
RATIONALE.md. It is derived from the Rust project's source, test suite and history
(https://github.com/rust-lang/rust, release 1.99.1, commit
58cf8f9c35b355199727627d07ae34a4e2846d67) and is licensed under the Rust project's
license: the Apache License 2.0 or the MIT license, at your option, both below.
Copyright (c) The Rust Project Contributors.
No third-party code that the Rust repository vendors or tracks separately (LLVM,
submodules, crates.io dependencies) is included; the injections touch only compiler/.

Everything else in this directory (the bin/ scripts, tool/, the README,
marauder.toml, bugs.csv, the reproducer scripts and notes written for this workload
(bugs/*/reproducer/repro.sh, bugs/*/reproducer/README.md), and the labels, review
notes and verification records in meta.json, oracle.json and RATIONALE.md) is
Copyright Datadog, Inc. and licensed under the Apache License 2.0 (../LICENSE).
"""


def write_licensing(out):
    up = {f: open(os.path.join(UPSTREAM, f)).read() for f in ("COPYRIGHT", "LICENSE-MIT", "LICENSE-APACHE")}
    rule = "-" * 76
    open(os.path.join(out, "LICENSE"), "w").write(
        "Licensing of the rustc/ workload\n================================\n\n" + DERIVED
        + "\nThe following are the Rust project's COPYRIGHT, LICENSE-MIT and LICENSE-APACHE files\n"
        "at release 1.99.1 (https://github.com/rust-lang/rust/tree/1.99.1), verbatim.\n"
        + "".join(f"\n{rule}\n{f}\n{rule}\n\n{up[f]}" for f in ("COPYRIGHT", "LICENSE-MIT", "LICENSE-APACHE")))
    open(os.path.join(out, "NOTICE"), "w").write(
        "Datadog etna-workloads: rustc\nCopyright 2026-Present Datadog, Inc.\n\n"
        "This product includes software developed at Datadog, Inc. (https://www.datadoghq.com/).\n\n"
        "This directory contains material derived from the Rust project\n"
        "(https://github.com/rust-lang/rust), licensed under the Apache License 2.0 or the MIT\n"
        "license, at your option; see LICENSE in this directory. The Rust project ships no NOTICE\n"
        "file; its copyright notice at release 1.99.1 (COPYRIGHT) is:\n\n"
        "Copyright (c) The Rust Project Contributors.\n")
    with open(os.path.join(out, "LICENSE-3rdparty.csv"), "w", newline="") as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(["Component", "Origin", "License", "Copyright"])
        w.writerow(["rust-lang/rust", "https://github.com/rust-lang/rust", "MIT OR Apache-2.0",
                    "Copyright (c) The Rust Project Contributors"])
    open(os.path.join(out, "marauder.toml"), "w").write(
        "# Marauders project config: the bugs are standalone patches under patches/\n"
        "# (one variation per file, activated with `git apply` at the rustc 1.99.1 checkout root).\n"
        'languages = []\nignore = []\nuse_gitignore = false\ncustom_languages = []\n')


def write_readme(out, rows, bs):
    """README with every number computed from the run's data."""
    C = collections.Counter
    cands = [json.loads(line) for line in open(os.path.join(DATA, "candidates.jsonl"))]
    tri = load_dir(os.path.join(DATA, "triage"))
    verb = load_dir(os.path.join(DATA, "verbatim"))
    adap = load_dir(os.path.join(DATA, "adapted"))
    anch = load_dir(os.path.join(DATA, "anchor"))
    spend = C()
    for line in open(os.path.join(DATA, "spend.jsonl")):
        x = json.loads(line)
        spend[x["stage"]] += x["cost"]
    strict = [b for b in bs if b["strict"]]
    st_tier = C(b["tier"] for b in strict)
    st_sym = C(b["triage"].get("symptom") for b in strict)
    st_year = C(b["c"]["date"][:4] for b in strict)
    n_rep = sum(1 for r in rows if r["reproducer"])
    n_rep_strict = sum(1 for r in rows if r["reproducer"] and r["strict"])
    loose = C(x for b in bs for x in b["loose_reasons"])
    sa = [b for b in strict if b["tier"] == "adapted"]
    loc = C(b["locality"] for b in sa)
    an = C(a["status"] for a in anch.values())
    rv = json.load(open(os.path.join(DATA, "review.json")))
    hv = C(v["verdict"] for v in rv["hand_review"].values())
    f = lambda n: f"{n:,}"  # noqa: E731
    sym = ", ".join(f"{k} {f(v)}" for k, v in st_sym.most_common())
    years = ", ".join(f"{k}: {f(v)}" for k, v in sorted(st_year.items()))
    text = f"""# rustc 1.99.1 bug workload

Historical bugs from the Rust compiler's fix history, each re-injected into the
**rustc 1.99.1** release (`58cf8f9c35b355199727627d07ae34a4e2846d67`) as a patch to
`compiler/`. Every bug is anchored in a real upstream fix commit and verified by the
project's own compiletest suites; none is invented. The standard library, LLVM,
submodules and tools are out of scope and never touched.

{f(len(rows))} bugs, **{f(len(strict))} strict** ({f(st_tier['verbatim'])} verbatim, {f(st_tier['adapted'])} adapted);
{f(n_rep)} have a standalone reproducer ({f(n_rep_strict)} of the strict ones).

## Contents

| Path | What |
|---|---|
| `bugs/<id>/injection.patch` | the bug, as a patch to the 1.99.1 tree (`git apply` at the root) |
| `bugs/<id>/meta.json` | fix commit, date, subject, PR and issue links, tier, strict flag and reasons, triage labels, locality, anchor result, review notes |
| `bugs/<id>/oracle.json` | the compiletest cases that pass on 1.99.1 (two runs) and the ones the bug makes fail (two runs) |
| `bugs/<id>/reproducer/` | `repro.sh` plus inputs, and the recorded clean and injected outputs |
| `bugs/<id>/RATIONALE.md` | how the injection relates to the fix (written by the agent for adapted bugs) |
| `patches/<id>.patch` | the same patches, one per file, for [Marauders](https://github.com/alpaylan/marauders) |
| `bugs.csv` | one line per bug |
| `bin/` | set up the release, apply/revert a bug, check it by reproducer or by tests |
| `tool/` | the pipeline that mined, injected, verified and exported these bugs |

## Usage

```sh
bin/setup.sh ~/rust-1.99.1            # clone 1.99.1, build stage-1 rustc + std (CI LLVM)
bin/apply.sh ~/rust-1.99.1 <id>       # inject a bug
bin/check_repro.sh ~/rust-1.99.1 <id> # rebuild, run the reproducer: BUG PRESENT / CLEAN
bin/check_tests.sh ~/rust-1.99.1 <id> # rebuild, run the bug's compiletest cases
bin/revert.sh ~/rust-1.99.1 <id>      # remove it again
```

Rebuilds are incremental (`./x build --stage 1 --keep-stage-std 1 compiler/rustc`): the
injections touch only `compiler/`, so std is built once. If the CI LLVM for 1.99.1 is no
longer downloadable, run `ETNA_BUILD_LLVM=1 bin/setup.sh ...` to build LLVM from the
submodule.

## How the bugs were made

1. **Candidates** ({f(len(cands))}): non-merge commits reachable from 1.99.1 that change
   `compiler/` and test files and read as fixes (issue references, fix wording).
   A cheap model triaged them: {", ".join(f"{k} {f(v)}" for k, v in C(t.get('label') for t in tri.values()).most_common())}.
2. **Oracle**: the fix's own test cases in the ui, crashes, mir-opt, codegen-llvm,
   codegen-units, incremental and assembly-llvm suites that pass in two runs on 1.99.1.
3. **Verbatim** ({f(len(verb))} tried, {f(C(v['status'] for v in verb.values())['gate_pass'])} pass the gate): the reverse of
   the fix's compiler hunks, applied to 1.99.1.
4. **Adapted** ({f(len(adap))} tried, newest first, {f(C(a['status'] for a in adap.values())['gate_pass'])} pass the gate): where the
   reversal no longer applies or no longer fails, an agent re-expresses the fix's bug in
   today's code; every changed hunk must trace to a hunk of the fix (RATIONALE.md).
5. **Gate** (all must hold): the patch applies, the compiler builds, at least one
   oracle case fails in two runs, and reversing the patch restores 1.99.1 byte for byte.
6. **Anchor** (adapted only): at the original fix commit, the fix's non-test changes
   reversed (the parent's code with the fix's tests) must fail some of the same cases.
   {f(len(anch))} anchors: {", ".join(f"{k} {f(v)}" for k, v in an.most_common())}.
7. **Strict** = gate + a failing case that the fix itself added + triage label "bug" +
   (adapted) anchor "exact". Looser bugs are kept and labelled (`strict: false`,
   `loose_reasons`): {", ".join(f"{k} {f(v)}" for k, v in loose.most_common())}.
8. **Reproducers**: a script whose output and exit status differ between the clean and
   the injected compiler, deterministic on the clean one, verified by a harness (never
   by an agent's word). Every exported reproducer was re-run from this directory with a
   clean 1.99.1 compiler and reproduces its recorded clean output.

Strict bugs by symptom: {sym}. By fix year: {years}.

Agent spend: {", ".join(f"{k} ${v:,.2f}" for k, v in spend.most_common())}; total ${sum(spend.values()):,.2f}.

## Caveats

- Adapted attempts ran newest first under a spend cap, so fixes before 2023 are
  barely represented.
- Locality (strict adapted: {", ".join(f"{k} {f(v)}" for k, v in loc.most_common())}) compares file paths;
  many "disjoint" injections sit in code the fix touched that later moved crates.
- A hand review of {len(rv['hand_review'])} random strict adapted bugs found {", ".join(f"{v} {k}" for k, v in hv.most_common())};
  flagged bugs carry `review` in meta.json (flagged, not dropped).
- Some anchors needed help to build old revisions: a `distutils` import shim for
  bootstraps from before 2023-01-30 (`anchor.python_compat` in meta.json) and LLVM
  built from the fix commit's own `src/llvm-project` submodule.
- Two compiletest cases exceed a 6 GiB per-process memory limit on 1.99.1 and are not
  used as oracles.

## License

See [LICENSE](LICENSE), [NOTICE](NOTICE) and [LICENSE-3rdparty.csv](LICENSE-3rdparty.csv):
material derived from the Rust project keeps its license (MIT OR Apache-2.0); everything
written for this workload is Copyright Datadog, Inc. under the Apache License 2.0.
"""
    open(os.path.join(out, "README.md"), "w").write(text)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=os.path.join(ROOT, "workload", "rustc"))
    a = ap.parse_args()
    out = a.out
    if os.path.exists(out):
        shutil.rmtree(out)
    os.makedirs(os.path.join(out, "bugs"))
    os.makedirs(os.path.join(out, "patches"))
    shutil.copytree(os.path.join(ROOT, "tools", "workload_bin"), os.path.join(out, "bin"),
                    ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
    bs = sorted(bugs(), key=lambda b: b["c"]["date"], reverse=True)
    rv = json.load(open(os.path.join(DATA, "review.json")))
    used = set()
    rows = []
    for b in bs:
        c, g = b["c"], b["gate"]
        name = name_for(b, used)
        d = os.path.join(out, "bugs", name)
        os.makedirs(d)
        open(os.path.join(d, "injection.patch"), "w").write(b["patch"])
        open(os.path.join(out, "patches", f"{name}.patch"), "w").write(b["patch"])
        r = b["repro"] if b["repro"] and b["repro"]["status"] in ("auto", "agent") else None
        if r and b["commit"] in REPRO_DROPPED:
            r = None
        if r:
            shutil.copytree(os.path.join(DATA, "repro", b["commit"]), os.path.join(d, "reproducer"),
                            ignore=repro_junk)
            for f in os.listdir(os.path.join(d, "reproducer")):
                p = os.path.join(d, "reproducer", f)
                if f.endswith((".md", ".sh")):
                    # Read before opening for write (which truncates); keep non-UTF-8 bytes
                    # (some reproducers feed invalid UTF-8 to the compiler) byte for byte.
                    text = scrub(open(p, errors="surrogateescape").read())
                    if f.endswith(".md"):  # notes may quote raw input bytes: keep them readable text
                        text = re.sub(r"[\x00-\x08\x0b-\x1f\x7f]|[\udc80-\udcff]",
                                      lambda m: "\\x%02x" % (ord(m.group()) & 0xff), text)
                    open(p, "w", errors="surrogateescape").write(text)
        vc = (r or {}).get("verdict", {})
        meta = dict(
            id=name, tier=b["tier"], strict=b["strict"], loose_reasons=b["loose_reasons"],
            fix_commit=b["commit"], fix_date=c["date"], fix_subject=c["subject"],
            pr=c.get("pr"), pr_url=f"https://github.com/rust-lang/rust/pull/{c.get('pr')}",
            commit_url=f"https://github.com/rust-lang/rust/commit/{b['commit']}",
            issues=[f"https://github.com/rust-lang/rust/issues/{n}" for n in c["issue_refs"]],
            release=RELEASE,
            triage={k: b["triage"].get(k) for k in ("label", "symptom", "subsystem", "confidence")},
            locality=b["locality"], fix_impl_files=c["impl_files"], injected_files=injected_files(b["patch"]),
            apply=g.get("apply"),
            anchor=None if not b["anchor"] else {k: b["anchor"].get(k) for k in ("status", "llvm", "shared_failing")},
            failing_cases=g["failing"], failing_cases_added_by_fix=g.get("failing_added_by_fix") or [],
            reproducer=None if not r else dict(kind=r["status"], from_case=r.get("case"),
                                               output_differs=vc.get("clean", {}).get("out") != vc.get("injected", {}).get("out"),
                                               exit_differs=vc.get("clean", {}).get("exit") != vc.get("injected", {}).get("exit")),
        )
        if b["commit"] in REPRO_DROPPED:
            meta["reproducer_dropped"] = REPRO_DROPPED[b["commit"]]
        if b["tier"] == "adapted":
            meta["agent_model"] = b["adapted"].get("model")
        hr, fl = rv["hand_review"].get(b["commit"]), rv["flags"].get(b["commit"])
        if hr or fl:  # step-8 quality review: flagged, never dropped
            meta["review"] = dict(hand_review=hr, flag=fl)
        if b["anchor"] and b["anchor"].get("python_compat"):
            meta["anchor"]["python_compat"] = b["anchor"]["python_compat"]
        json.dump(meta, open(os.path.join(d, "meta.json"), "w"), indent=1)
        json.dump(dict(oracle=g["oracle"], failing=g["failing"],
                       failing_added_by_fix=g.get("failing_added_by_fix") or [],
                       runner="./x test --stage 1 --keep-stage-std 1 --force-rerun <case files>",
                       note="cases pass in two base runs; 'failing' fail in two injected runs"),
                  open(os.path.join(d, "oracle.json"), "w"), indent=1)
        if b["tier"] == "adapted":
            rat = os.path.join(DATA, "adapted", "notes", b["commit"], "RATIONALE.md")
            text = open(rat).read() if os.path.exists(rat) else "(agent wrote no RATIONALE.md)\n"
            text = f"# Adapted injection for {c['subject']}\n\nFix: {meta['commit_url']}\n\n" + text
        else:
            text = (f"# Verbatim injection for {c['subject']}\n\nFix: {meta['commit_url']}\n\n"
                    f"The injection is the reverse of the fix's implementation hunks, applied to {RELEASE} "
                    f"({g.get('apply')}).\n")
        open(os.path.join(d, "RATIONALE.md"), "w").write(scrub(text))
        rows.append(dict(id=name, tier=b["tier"], strict=b["strict"], fix_commit=b["commit"], date=c["date"][:10],
                         symptom=b["triage"].get("symptom"), label=b["triage"].get("label"),
                         reproducer=meta["reproducer"]["kind"] if meta["reproducer"] else "",
                         subject=c["subject"]))
    with open(os.path.join(out, "bugs.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    write_licensing(out)
    write_readme(out, rows, bs)
    cnt = collections.Counter((r["tier"], r["strict"]) for r in rows)
    print(f"exported {len(rows)} bugs to {out}: {dict(cnt)}")


if __name__ == "__main__":
    _ = git
    main()
