#!/usr/bin/env python3
"""Export the DataFusion workload (ETNA_KIND=datafusion): one directory per
bug, injected into DataFusion 55.2.0. Same layout as the other workloads.

  <out>/README.md, index.jsonl, marauder.toml
  <out>/patches/datafusion_<id>.patch  the injections as Marauders variants
  <out>/bin/setup.sh DEST              clone 55.2.0 (with test data) and add the variants
  <out>/bin/apply.sh BUG TREE [-R]     apply (or remove) one injection
  <out>/bin/check-repro.sh BUG TREE    build TREE's datafusion-cli, run the reproducer
  <out>/bin/check-test.sh BUG TREE     run the upstream .slt oracle files in TREE
  <out>/bugs/<id>/ injection.patch meta.json oracle.json
                   repro.sql expected.txt expected-status.txt NOTES.md
                   RATIONALE.md (adapted)

Only strict bugs: anchored, and a case in a test file the fix touched fails.

Usage:
  export_datafusion.py [--out DIR]
"""

import argparse
import collections
import json
import re
import shutil
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import sqlite_etna as E  # noqa: E402
from export_go import _scrub, _machine_local  # noqa: E402

APPLY = """\
#!/bin/bash
# Apply a bug's injection to an unmodified DataFusion 55.2.0 source tree.
#   bin/apply.sh <bug-id> <datafusion-55.2.0-tree> [-R]   (-R removes it again)
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
patch -p1 --batch ${3:-} -d "$2" < "$here/bugs/$1/injection.patch"
"""

SETUP = """\
#!/bin/bash
# Make a Marauders project out of DataFusion 55.2.0 and this workload's bugs.
#   bin/setup.sh <dest>
# The test-data submodules are included (the .slt oracles need them). Then
# use marauders list|set|unset --path <dest> [--variant datafusion_<id>];
# the check scripts rebuild what changed.
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
dest="${1:?usage: bin/setup.sh <dest>}"
if [ -e "$dest" ]; then echo "$dest already exists" >&2; exit 1; fi
git clone --quiet --depth 1 --branch 55.2.0 --recurse-submodules --shallow-submodules \\
  https://github.com/apache/datafusion.git "$dest"
cp -R "$here/patches" "$dest/patches"
cp "$here/marauder.toml" "$dest/marauder.toml"
echo "DataFusion 55.2.0 with $(ls "$dest/patches" | wc -l | tr -d ' ') bug variants in $dest"
"""

CHECK_REPRO = r"""#!/bin/bash
# Build TREE's datafusion-cli (incrementally) and run a bug's reproducer with
# it, comparing with clean 55.2.0. Exit 0: same as clean (bug not observed);
# 1: different (bug observed); 2: no reproducer for this bug.
#   bin/check-repro.sh <bug-id> <datafusion-tree>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
d="$here/bugs/$1"; tree="$(cd "$2" && pwd)"
[ -f "$d/repro.sql" ] || { echo "no standalone reproducer for $1 (see oracle.json)"; exit 2; }
(cd "$tree" && cargo build -q -p datafusion-cli --bin datafusion-cli) || { echo "build failed"; exit 3; }
cli="${CARGO_TARGET_DIR:-$tree/target}/debug/datafusion-cli"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cp "$d/repro.sql" "$tmp/"
cd "$tmp"
out="$(env -i PATH="$PATH" HOME="$tmp" TZ=UTC RUST_BACKTRACE=0 LANG=C.UTF-8 \
  timeout --kill-after=5 120 "$cli" -q --format table -f repro.sql 2>&1)"; st=$?
[ "$st" = 124 ] && st=timeout && out="$out
[timeout]"
out="$(printf '%s' "$out" | sed -e "s#$tmp#\$WORK#g" -e "s#$tree/#\$SRC/#g")"
if [ "$out" = "$(cat "$d/expected.txt")" ] && [ "$st" = "$(cat "$d/expected-status.txt")" ]; then
  echo "same as clean 55.2.0"; exit 0
fi
echo "differs from clean 55.2.0 (exit status $st):"; printf '%s\n' "$out" | tail -20; exit 1
"""

CHECK_TEST = r"""#!/bin/bash
# Run a bug's upstream oracle files (SQL logic tests) in TREE.
# Exit 1 when an oracle file fails (bug observed), 0 when all pass.
#   bin/check-test.sh <bug-id> <datafusion-tree>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
tree="$(cd "$2" && pwd)"
bad=0
for f in $(python3 -c 'import json,sys; print(" ".join(json.load(open(sys.argv[1]))["files"]))' "$here/bugs/$1/oracle.json"); do
  rel="${f#datafusion/sqllogictest/test_files/}"
  if (cd "$tree" && cargo test -q -p datafusion-sqllogictest --test sqllogictests -- "$rel" > /dev/null 2>&1); then
    echo "pass  $f"
  else
    echo "FAIL  $f"; bad=1
  fi
done
exit $bad
"""

MARAUDER = """\
languages = []
ignore = ["target", "testing", "parquet-testing", "datafusion-testing", "docs", "benchmarks"]
use_gitignore = false
custom_languages = []
"""


def first_release(commit):
    r = E.git("describe", "--contains", "--match", "[0-9]*.[0-9]*.[0-9]", "--match", "[0-9]*.[0-9]*.[0-9][0-9]",
              commit, check=False)
    m = re.match(r"(\d+\.\d+\.\d+)", r.stdout.strip())
    return m.group(1) if m else None


def readme(entries, target):
    c = lambda k: ", ".join(f"{v} {k2}" for k2, v in collections.Counter(e[k] for e in entries).most_common())
    n = len(entries)
    nrep = sum(1 for e in entries if e["repro"])
    years = collections.Counter(e["fix_date"][:4] for e in entries)
    return f"""# DataFusion 55.2.0 workload

{n} historical bugs in Apache DataFusion, each re-injected into **DataFusion
55.2.0** (git {target[:12]}) as a patch, for evaluating testing tools. Every
bug comes from an upstream fix commit; the injection brings back the
behaviour that commit fixed.

- Provenance: {c("provenance")}
  - verbatim: the upstream fix's implementation hunks, reversed on 55.2.0
  - adapted: re-expressed on 55.2.0 by a Claude agent (claude-sonnet-5-5)
    where the old hunks no longer apply; RATIONALE.md maps each hunk to the
    fix. Anchored: at the original fix commit, the pre-fix code fails the
    same test files.
- Fix years: {", ".join(f"{y}: {years[y]}" for y in sorted(years))}
- Symptoms: {c("symptom")}
- Standalone reproducers: {nrep} of {n} (repro.sql, run with datafusion-cli)
- Locality: {c("locality")}

Every bug is "strict": a SQL logic test file (`.slt`) that the upstream fix
touched fails with the injection and passes on clean 55.2.0 (in both of two
runs), and triage labels the fix a bug fix. The oracle is the `.slt` file:
DataFusion's Rust unit tests live in the same files as the code, so a
reversed fix could delete them. Implementation files are the Rust sources of
the `datafusion/*` crates.

## Use

    bin/setup.sh /tmp/df-55.2.0                       # 55.2.0 + Marauders variants
    cd /tmp/df-55.2.0
    marauders set --path . --variant datafusion_<id>  # or: bin/apply.sh <id> <tree>
    bin/check-repro.sh <id> /tmp/df-55.2.0            # 1 = bug observed
    bin/check-test.sh  <id> /tmp/df-55.2.0            # 1 = an oracle file fails
    marauders unset --path . --variant datafusion_<id>

The check scripts build what they need with cargo (incrementally; the first
build takes a while). Reproducers run `datafusion-cli -q --format table -f
repro.sql` in an empty directory, with `HOME` set to that directory, `TZ=UTC`
and `RUST_BACKTRACE=0`.

## Per bug (bugs/<id>/)

- injection.patch (also patches/datafusion_<id>.patch)
- meta.json: fix commit, date, subject, issue/PR references, first release
  containing the fix, provenance, labels (kind, symptom, subsystem),
  injected and fix files, locality, anchor
- oracle.json: the `.slt` files that fail (a case is a whole file)
- repro.sql, expected.txt, expected-status.txt, NOTES.md
- RATIONALE.md (adapted only)

The id is the first 12 hex digits of the fix's commit in
https://github.com/apache/datafusion.
"""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(E.ROOT / "export" / "datafusion"))
    a = ap.parse_args()
    out = Path(a.out)
    if out.exists():
        shutil.rmtree(out)
    for d in ("bugs", "bin", "patches"):
        (out / d).mkdir(parents=True)

    cands, tri, reps = E.candidates(), E.latest("triage"), E.latest("repro")
    target = E.target_commit()
    entries = []

    def add(cid, prov, patch, failing, added, extra):
        t = tri.get(cid, {})
        if not added or t.get("kind") != "bug" or t.get("confidence") == "low":
            return
        c, bid = cands[cid], cid[:12]
        d = out / "bugs" / bid
        d.mkdir()
        shutil.copy(patch, d / "injection.patch")
        shutil.copy(patch, out / "patches" / f"datafusion_{bid}.patch")
        inj_files = sorted(set(re.findall(r"^\+\+\+ b/(\S+)", patch.read_text(), re.M)))
        files = sorted(failing)
        (d / "oracle.json").write_text(json.dumps({
            "files": files,
            "note": "upstream SQL logic test files (55.2.0's datafusion/sqllogictest/test_files) touched by the fix, "
                    "that pass on clean 55.2.0 in two runs and fail with the injection in two runs"}, indent=2) + "\n")
        r = reps.get(cid, {})
        if r.get("result") == "confirmed" and not _machine_local(E.DATASET / "repro" / bid):
            for f in ("repro.sql", "expected.txt", "expected-status.txt", "NOTES.md"):
                src = E.DATASET / "repro" / bid / f
                if src.exists():
                    shutil.copy(src, d / f)
            _scrub(d / "NOTES.md")
        else:
            r = {}
        rat = E.DATASET / "adapted-sonnet" / bid / "RATIONALE.md"
        if prov == "adapted" and rat.exists():
            shutil.copy(rat, d / "RATIONALE.md")
            _scrub(d / "RATIONALE.md")
        meta = {
            "id": bid, "fix_commit": cid, "fix_date": c["date"][:10], "fix_subject": c["subject"],
            "reports": c.get("reports", []), "fixed_in_release": first_release(cid),
            "provenance": prov, "tier": "strict",
            "kind": t.get("kind"), "symptom": t.get("symptom"), "subsystem": t.get("subsystem"),
            "triage_confidence": t.get("confidence"),
            "injected_files": inj_files, "fix_impl_files": c["impl_files"],
            "locality": ("subset" if set(inj_files) <= set(c["impl_files"]) else
                         "overlap" if set(inj_files) & set(c["impl_files"]) else "disjoint"),
            "oracle_test_files": files,
            "repro": r.get("kind") if r.get("result") == "confirmed" else None, **extra}
        (d / "meta.json").write_text(json.dumps(meta, indent=2) + "\n")
        entries.append(meta)

    for r in E.latest("verbatim").values():
        if r.get("result") == "confirmed":
            p = E.DATASET / "bugs" / r["id"][:12] / "injection.patch"
            if p.exists():
                add(r["id"], "verbatim", p, r["attempt"]["oracle_failing"], r.get("fix_added_failing") or {},
                    {"apply_mode": r["attempt"].get("apply")})
    seen = {e["fix_commit"] for e in entries}
    for r in E.latest("adapt-sonnet").values():
        if r["id"] in seen or r.get("result") != "adapted_confirmed":
            continue
        p = E.DATASET / "adapted-sonnet" / r["id"][:12] / "injection.patch"
        if p.exists():
            add(r["id"], "adapted", p, r["attempt"]["oracle_failing"], r.get("fix_added_failing") or {},
                {"anchor": r.get("anchor"), "signature_equivalence": r.get("signature_equivalence"),
                 "model": r.get("model")})

    entries.sort(key=lambda e: e["fix_date"])
    with open(out / "index.jsonl", "w") as f:
        for e in entries:
            f.write(json.dumps(e, sort_keys=True) + "\n")
    for name, text in (("apply.sh", APPLY), ("setup.sh", SETUP), ("check-repro.sh", CHECK_REPRO),
                       ("check-test.sh", CHECK_TEST)):
        (out / "bin" / name).write_text(text)
        (out / "bin" / name).chmod(0o755)
    (out / "marauder.toml").write_text(MARAUDER)
    (out / "README.md").write_text(readme(entries, target))
    print(f"{len(entries)} bugs -> {out}")
    for k in ("provenance", "repro", "symptom", "locality"):
        print(f"  {k}: {dict(collections.Counter(e[k] for e in entries).most_common())}")


if __name__ == "__main__":
    main()
