"""Export the dataset to ~/ocaml-etna/workload (one directory per gated bug)."""
import json, os, re, shutil, subprocess
from pathlib import Path
from common import *
import report

OUTD = ROOT / "workload"
REF_GH = re.compile(r"(?<![\w/])#(\d{3,6})\b|\bgh-?(\d{3,6})\b|\bGPR#?(\d{3,6})\b", re.I)
REF_MANTIS = re.compile(r"\bM?PR\s*#?\s*(\d{4})\b")
LOCAL = re.compile(r"/home/[^\s'\"]*|/tmp/[^\s'\"]*")


def slug(s):
    s = re.sub(r"[^a-z0-9]+", "-", (s or "misc").lower()).strip("-")
    return s[:24] or "misc"


def links(c):
    text = c["subject"] + "\n" + c["body"]
    news = git("diff", "-U0", f"{c['sha']}^", c["sha"], "--", "Changes", check=False)
    news = "\n".join(l[1:] for l in news.splitlines() if l.startswith("+") and not l.startswith("+++"))
    gh = sorted({int(n) for m in REF_GH.finditer(text + "\n" + news) for n in m.groups() if n})
    mantis = sorted({int(m.group(1)) for m in REF_MANTIS.finditer(text + "\n" + news)})
    out = [f"https://github.com/ocaml/ocaml/commit/{c['sha']}"]
    out += [f"https://github.com/ocaml/ocaml/issues/{n}" for n in gh]
    out += [f"https://caml.inria.fr/mantis/view.php?id={n}" for n in mantis]
    return out, news


def scrub(text):
    return LOCAL.sub("<local-path>", text)


SPDX = "LGPL-2.1-only WITH OCaml-LGPL-linking-exception"
OCAML_COPYRIGHT = ("Copyright (C) 1996-2023 Institut National de Recherche en Informatique et en "
                   "Automatique (INRIA), and other OCaml contributors")


def write_license_files():
    (OUTD / "LICENSE.upstream").unlink(missing_ok=True)
    upstream = git("show", f"{RELEASE}:LICENSE")
    head = f"""Licensing of the ocaml/ workload
================================

Material derived from OCaml: the injection patches (bugs/*/injection.patch, patches/), the
reproducers (bugs/*/reproducer/: repro.sh, the program file, expected-clean.txt,
expected-buggy.txt; derived from OCaml's tests), and the OCaml test names, code excerpts and
commit messages quoted in oracle.json, meta.json and RATIONALE.md. It is derived from OCaml's
source, test suite and history (https://github.com/ocaml/ocaml, release {RELEASE}) and is
licensed under OCaml's licence: the GNU Lesser General Public License version 2.1 with OCaml's
special exception on linking (SPDX: {SPDX}), below.
All files marked "Copyright INRIA" in the OCaml distribution are Copyright (C) 1996-2023
Institut National de Recherche en Informatique et en Automatique (INRIA); other files are
copyright their respective OCaml contributors, as marked in each file.

Each injection patch is a modification of the OCaml files it names; see README.md for the
notices of changes.

Everything else in this directory (the bin/ scripts, tool/, the README, marauder.toml,
bugs.csv, bugs.json, and the labels and verification records in meta.json, oracle.json and
RATIONALE.md) is Copyright Datadog, Inc. and licensed under the Apache License 2.0
(../LICENSE).

The following is OCaml's LICENSE file at tag {RELEASE}
(https://github.com/ocaml/ocaml/blob/{RELEASE}/LICENSE), verbatim:

----------------------------------------------------------------------------

"""
    (OUTD / "LICENSE").write_text(head + upstream)
    (OUTD / "NOTICE").write_text(f"""Datadog etna-workloads: ocaml
Copyright 2026-Present Datadog, Inc.

This product includes software developed at Datadog, Inc. (https://www.datadoghq.com/).

This directory contains material derived from OCaml (https://github.com/ocaml/ocaml),
licensed under the GNU Lesser General Public License version 2.1 with OCaml's special
exception on linking; see LICENSE in this directory. OCaml ships no NOTICE file; its
copyright statement at {RELEASE} (README.adoc) is:

All files marked "Copyright INRIA" in this distribution are
Copyright (C) 1996-2023 Institut National de Recherche en Informatique et
en Automatique (INRIA) and distributed under the conditions stated in
file LICENSE.
""")
    (OUTD / "LICENSE-3rdparty.csv").write_text(
        "Component,Origin,License,Copyright\n"
        f'ocaml,https://github.com/ocaml/ocaml,{SPDX},"{OCAML_COPYRIGHT}"\n')


def write_bugs_csv(index):
    import csv
    with open(OUTD / "bugs.csv", "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["name", "tier", "strict", "fix_date", "symptom", "reproducer", "fix_subject"])
        for e in index:
            w.writerow([e["name"], e["tier"], str(e["strict"]).lower(), e["date"], e["symptom"],
                        str(e["reproducer"]).lower(), e["subject"]])


def write_readme(index):
    from collections import Counter
    st = [e for e in index if e["strict"]]
    tiers = Counter(e["tier"] for e in index)
    years = Counter(e["date"][:4] for e in st)
    syms = Counter(e["symptom"] for e in st)
    lines = [
        f"# OCaml {RELEASE}: injected historical bugs",
        "",
        f"Bugs from the OCaml compiler/runtime fix history, re-injected into the {RELEASE} release as",
        "patches. Every bug is anchored in a real upstream fix commit and verified by tests.",
        "",
        "## Counts",
        "",
        f"- bugs: {len(index)} ({tiers['verbatim']} verbatim, {tiers['adapted']} adapted)",
        f"- **strict: {len(st)}** ({sum(e['tier']=='verbatim' for e in st)} verbatim, "
        f"{sum(e['tier']=='adapted' for e in st)} adapted); "
        f"{sum(e['reproducer'] for e in st)} with a verified reproducer",
        f"- reproducers (all bugs): {sum(e['reproducer'] for e in index)} / {len(index)}",
        "- strict by year: " + ", ".join(f"{y}: {n}" for y, n in sorted(years.items())),
        "- strict by symptom: " + ", ".join(f"{k}: {n}" for k, n in syms.most_common()),
        "",
        "Use `strict` bugs for headline numbers; the others are kept and labelled in `meta.json`.",
        "",
        "## Definitions",
        "",
        "- **Base**: the release configured as upstream CI configures it for its tests",
        "  (`--enable-ocamltest --enable-native-toplevel`), tests run with the debug runtime",
        "  (`USE_RUNTIME=d`, C assertions enabled).",
        "- **Oracle** (`oracle.json`): test files (ocamltest reports one result per file) from the",
        "  fix's own test files that pass on the base in two runs.",
        "- **Gate**: the injection applies; the tree builds (clean rebuild); at least one oracle test",
        "  fails in two runs; reversing the injection restores the release byte for byte.",
        "- **verbatim**: the fix's implementation hunks, reversed, applied to the release (exactly or",
        "  with fuzz). **adapted**: an agent re-expressed the fix's bug in today's code (`RATIONALE.md`),",
        "  accepted only with an *anchor*: at the original fix commit, the fix's implementation reversed",
        "  fails some of the same oracle tests (`meta.json: anchor.result == \"exact\"`).",
        "- **strict**: passes the gate; a failing test is a test file the fix itself *added*; triage",
        "  labels it a bug; adapted bugs need an exact anchor and must trace hunk-by-hunk to the fix",
        "  (`traceability == \"traces\"`); near-duplicates (same fix split over commits) are counted",
        "  once (`duplicate_of`).",
        "- **reproducer**: `reproducer/repro.sh PREFIX` (+ one program file) whose output and exit",
        "  status differ between the clean and the injected installed compiler; verified by the harness.",
        "",
        "## Layout",
        "",
        "- `bugs/<name>/`: `injection.patch`, `meta.json`, `oracle.json`, `RATIONALE.md`,",
        "  `reproducer/` (`repro.sh`, program, `expected-clean.txt`, `expected-buggy.txt`)",
        "- `patches/<name>.patch`: the same injections, for Marauders (`marauder.toml`)",
        "- `bugs.json`, `bugs.csv`: index",
        "- `bin/`: scripts (below)",
        "- `tool/`: the clean-room pipeline that produced the dataset (mining, gate, agents,",
        "  anchors, traceability check, reproducers, export); see `tool/run_all.sh`. Agents are",
        "  run with the `claude` CLI; set `ETNA_API_KEY_HELPER` to use an `apiKeyHelper` command.",
        "  Two configuration details were made portable after the run, with no change in logic:",
        "  that helper setting (previously site-specific) and the sandbox's deny paths (now",
        "  computed from the tool's location).",
        "",
        "## Usage",
        "",
        "```sh",
        "bin/setup.sh TREE                   # clone the release tag, configure, build",
        "bin/check-tests.sh TREE BUG         # CLEAN (0) / BUG DETECTED (1)",
        "bin/apply.sh TREE BUG && bin/build.sh TREE",
        "bin/check-tests.sh TREE BUG         # -> BUG DETECTED",
        "bin/check-repro.sh TREE BUG         # installs TREE into TREE/_inst, runs the reproducer",
        "bin/revert.sh TREE BUG && bin/build.sh TREE",
        "```",
        "",
        "`bin/build.sh` always rebuilds clean: incremental builds after stdlib/runtime edits can",
        "produce inconsistent-assumption errors.",
        "",
        "## Known gaps",
        "",
        "- Anchors for fixes older than ocamltest (before about 2017-09) cannot run the oracle (the",
        "  legacy Makefile testsuite was not ported); those adapted bugs are not strict.",
        "- Anchor builds of old revisions use compatibility settings for a modern toolchain (no",
        "  `-Werror`, `CC=\"gcc -fcommon\"`, a fixed-size alternate signal stack); recorded in",
        "  `meta.json: anchor.build_env`.",
        "- Windows-only fixes cannot fail on Linux and were not adapted.",
        "- Some oracle tests are timing-sensitive (e.g. systhreads yield fairness); they passed both",
        "  base runs and failed both injected runs.",
        "- `tool/anchor.py` times out `ocamltest` but not the test programs it started, so an anchor",
        "  whose bug shows as a hang can leave orphaned processes; kill them after a run.",
        "",
        "## License",
        "",
        "Material derived from OCaml (the injection patches, the reproducers, which are derived from",
        "OCaml's tests, and the test names and commit messages quoted in the records) is licensed under",
        "OCaml's licence, the LGPL-2.1 with OCaml's special exception on linking",
        f"(`{SPDX}`); everything else here is Copyright Datadog, Inc. under",
        "Apache-2.0 (`../LICENSE`). See `LICENSE` and `NOTICE`.",
        "",
        "### Notices of changes (LGPL-2.1 section 2)",
        "",
        f"Each `bugs/<name>/injection.patch` (and its copy `patches/<name>.patch`) is a modification",
        f"of the OCaml {RELEASE} files named in its `diff --git` headers: it re-introduces a historical",
        "bug into those files. The upstream fix it is derived from is recorded in",
        "`bugs/<name>/meta.json` (`fix_commit`, `fix_date`, `fix_subject`, `report_links`), and the",
        f"original, unmodified source is the OCaml {RELEASE} release",
        f"(https://github.com/ocaml/ocaml/tree/{RELEASE}), which `bin/setup.sh` clones. The",
        "modifications were made in 2026 by Datadog, Inc.",
        "",
    ]
    (OUTD / "README.md").write_text("\n".join(lines))


def main():
    if OUTD.exists():
        shutil.rmtree(OUTD / "bugs", ignore_errors=True)
        shutil.rmtree(OUTD / "patches", ignore_errors=True)
    (OUTD / "bugs").mkdir(parents=True, exist_ok=True)
    (OUTD / "patches").mkdir(parents=True, exist_ok=True)
    cands = {c["sha"]: c for c in load("candidates.json")}
    base = load("base.json")
    index = []
    for b in report.bugs():
        c = cands[b["sha"]]
        tierdir = "verbatim" if b["tier"] == "verbatim" else "adapted"
        r = json.loads((DATA / tierdir / f"{c['sha']}.json").read_text())
        pdir = DATA / ("patches" if b["tier"] == "verbatim" else "patches_adapted")
        inj = (pdir / f"{c['sha']}.patch").read_text(errors="surrogateescape")
        name = f"{slug(b['subsystem'])}_{c['sha'][:8]}"
        d = OUTD / "bugs" / name
        d.mkdir(parents=True)
        (d / "injection.patch").write_text(inj, errors="surrogateescape")
        (OUTD / "patches" / f"{name}.patch").write_text(inj, errors="surrogateescape")
        lk, news = links(c)
        anchor = None
        if b["tier"] == "adapted":
            af = DATA / "anchor" / f"{c['sha']}.json"
            if af.exists():
                a = json.loads(af.read_text())
                anchor = dict(result=a["anchor"], failing_at_anchor=a.get("failing", []),
                              build_env=a.get("build_env"))
        meta = dict(
            name=name, fix_commit=c["sha"], fix_date=c["date"], fix_subject=c["subject"],
            fix_author=c["author"], changes_entry=news or None, report_links=lk,
            tier=b["tier"], verbatim_mode=r.get("mode") if b["tier"] == "verbatim" else None,
            agent_model=r.get("model") if b["tier"] == "adapted" else None,
            strict=b["strict"], fails_fix_added_test=b["fails_added"],
            labels=dict(triage=b["label"], symptom=b["symptom"], subsystem=b["subsystem"],
                        triage_model="haiku"),
            locality=b["locality"], anchor=anchor, traceability=b["trace"], duplicate_of=b["duplicate_of"],
            injection_files=r["files"], fix_impl_files=c["impl_files"], fix_test_files=c["test_files"],
            reproducer=b["repro"], release=RELEASE)
        (d / "meta.json").write_text(json.dumps(meta, indent=1))
        oracle = dict(runner="ocamltest (per test file), run from testsuite/ with USE_RUNTIME=d",
                      oracle=r["oracle"], failing=r["failing"],
                      fix_added_tests=r.get("fix_added_units", []),
                      base={u: [base[u]["run1"], base[u]["run2"]] for u in r["oracle"]},
                      injected=[{u: run[u] for u in r["oracle"]} for run in r["runs"]])
        (d / "oracle.json").write_text(json.dumps(oracle, indent=1))
        if b["tier"] == "adapted":
            rat = r.get("rationale") or "(the agent did not write RATIONALE.md)"
        else:
            rat = (f"# Verbatim injection\n\nThe implementation hunks of upstream commit {c['sha']} "
                   f"(\"{c['subject']}\") reversed and applied to OCaml {RELEASE} "
                   f"({'exactly' if r.get('mode') == 'exact' else 'with offsets/fuzz'}).\n"
                   f"Files: {', '.join(r['files'])}\n")
        (d / "RATIONALE.md").write_text(scrub(rat))
        rp = DATA / "repro" / f"{c['sha']}.json"
        if b["repro"]:
            rr = json.loads(rp.read_text())
            rd = d / "reproducer"
            shutil.copytree(DATA / "repro_files" / c["sha"], rd)
            for kind, runs in (("clean", rr["clean"]), ("buggy", rr["buggy"])):
                out, rc = runs[0]
                (rd / f"expected-{kind}.txt").write_text(out.rstrip("\n") + f"\nexit={rc}\n")
        index.append(dict(name=name, tier=b["tier"], strict=b["strict"], date=c["date"][:10],
                          symptom=b["symptom"], reproducer=b["repro"], subject=c["subject"]))
    (OUTD / "bugs.json").write_text(json.dumps(index, indent=1))
    lines = ["languages = []", "ignore = []", "use_gitignore = true", "custom_languages = []", ""]
    (OUTD / "marauder.toml").write_text("\n".join(lines))
    shutil.rmtree(OUTD / "bin", ignore_errors=True)
    shutil.copytree(TOOLS / "export_bin", OUTD / "bin")
    write_license_files()
    write_bugs_csv(index)
    write_readme(index)
    print("exported", len(index), "bugs;", sum(e["strict"] for e in index), "strict")


if __name__ == "__main__":
    main()
