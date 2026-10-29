#!/usr/bin/env python3
"""Export the dataset: one directory per bug, injected into SQLite 3.54.1.

  <out>/README.md
  <out>/index.jsonl                one line per bug (the meta.json fields)
  <out>/bin/apply.sh BUG TREE      apply a bug's injection to a 3.54.1 tree
  <out>/bin/check-repro.sh BUG CLI run the standalone reproducer: exit 0 when
                                   CLI behaves like clean 3.54.1, 1 when not
  <out>/bin/check-test.sh BUG TF TREE
                                   run the upstream oracle test files with a
                                   testfixture: exit 1 when an oracle case fails
  <out>/bugs/<id>/
      injection.patch   meta.json   oracle.json
      repro.sql | repro.sh, expected.txt, expected-status.txt, NOTES.md
      RATIONALE.md      (adapted tier: the agent's hunk-by-hunk rationale)

Tiers:
  strict   anchored (verbatim: the upstream reversal itself; adapted: exact
           signature at the fix commit) and a test case the fix added fails
  loose    every other confirmed injection (kept, labelled)

Usage:
  export.py [--out DIR] [--include-loose]
"""

import argparse
import json
import re
import shutil
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import sqlite_etna as E  # noqa: E402

APPLY = """\
#!/bin/bash
# Apply a bug's injection to an unmodified SQLite 3.54.1 source tree.
#   bin/apply.sh <bug-id> <sqlite-3.54.1-tree> [-R]   (-R removes it again)
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
patch -p1 --batch ${3:-} -d "$2" < "$here/bugs/$1/injection.patch"
"""

CHECK_REPRO = """\
#!/bin/bash
# Run a bug's standalone reproducer with a sqlite3 shell and compare it with
# the clean 3.54.1 output. Exit 0: same as clean (bug not observed);
# exit 1: different (bug observed); exit 2: no reproducer for this bug.
# The expected output comes from a shell built like testfixture:
#   ./configure --all --geopoly --session --debug CFLAGS="-g -O0"; make sqlite3
#   bin/check-repro.sh <bug-id> <path-to-sqlite3>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
d="$here/bugs/$1"; cli="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cd "$tmp"
if [ -f "$d/repro.sql" ]; then
  out="$(timeout 10 "$cli" -batch -init /dev/null :memory: < "$d/repro.sql" 2>&1)"; st=$?
elif [ -f "$d/repro.sh" ]; then
  out="$(SQLITE3="$cli" timeout 10 bash "$d/repro.sh" 2>&1)"; st=$?
else
  echo "no standalone reproducer for $1 (see oracle.json)"; exit 2
fi
[ "$st" = 124 ] && st=timeout && out="$out
[timeout]"
if [ "$out" = "$(cat "$d/expected.txt")" ] && [ "$st" = "$(cat "$d/expected-status.txt")" ]; then
  echo "same as clean 3.54.1"; exit 0
fi
echo "differs from clean 3.54.1 (exit status $st):"; printf '%s\\n' "$out" | tail -20; exit 1
"""

CHECK_TEST = """\
#!/bin/bash
# Run a bug's upstream oracle test files with a testfixture built from TREE
# (the 3.54.1 tree it was built from, which holds test/). Exit 1 when any
# oracle case fails (bug observed), 0 when all pass.
#   bin/check-test.sh <bug-id> <path-to-testfixture> <tree>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
tf="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"; tree="$(cd "$3" && pwd)"
python3 - "$here/bugs/$1/oracle.json" "$tf" "$tree" <<'PY'
import json, re, subprocess, sys, tempfile
oracle, tf, tree = json.load(open(sys.argv[1])), sys.argv[2], sys.argv[3]
bad = {}
for f, names in oracle["cases"].items():
    with tempfile.TemporaryDirectory() as cwd:
        try:
            out = subprocess.run([tf, f"{tree}/{f}"], cwd=cwd, capture_output=True, timeout=900).stdout.decode("utf-8", "replace")
        except subprocess.TimeoutExpired as e:
            out = (e.stdout or b"").decode("utf-8", "replace")
    ok = {m.group(1) for m in re.finditer(r"^(\\S+)\\.\\.\\. *Ok\\s*$", out, re.M)}
    failed = set()
    for m in re.finditer(r"Failures on these tests:\\s*(.*)$", out, re.M):
        failed |= set(m.group(1).split())
    miss = [n for n in names if n not in ok - failed]
    if miss:
        bad[f] = miss
if bad:
    print("oracle cases failing:", json.dumps(bad)); sys.exit(1)
print("all oracle cases pass"); sys.exit(0)
PY
"""


def readme(entries):
    from collections import Counter
    c = lambda k: ", ".join(f"{v} {k2}" for k2, v in Counter(e[k] for e in entries).most_common())
    n = len(entries)
    nrep = sum(1 for e in entries if e["repro"])
    return f"""# sqlite-etna 3.54.1

{n} historical SQLite bugs, each re-injected into **SQLite 3.54.1** (git
{E.target_commit()[:12]}) as a patch, for evaluating testing tools. Every bug
comes from an upstream fix commit; the injection brings back the behaviour
that commit fixed.

- Provenance: {c("provenance")}
  - verbatim: the upstream fix's implementation hunks, reversed exactly (or
    with fuzz) on 3.54.1
  - adapted: re-expressed on 3.54.1 by a Claude agent (claude-sonnet-5-5)
    where the old hunks no longer apply; RATIONALE.md maps each hunk to the
    fix. Anchored: at the original fix commit, the pre-fix code fails the
    same upstream test cases (signature_equivalence = exact).
- Symptoms: {c("symptom")}
- Standalone reproducers: {nrep} of {n} ({c("repro")}); the rest keep only the
  test-level oracle (mostly simulated OOM/IO-error and crash-test bugs)
- Locality: {c("locality")} (injected files vs the fix's files; "disjoint"
  includes code that moved, e.g. ext/misc/json1.c -> src/json.c)
- Found by ephyra: {sum(1 for e in entries if e["found_by_ephyra"])}. Most other ephyra-found bugs were fixed upstream after
  3.54.1 was cut, so 3.54.1 already contains them unfixed.

Every bug here is "strict": a test case the upstream fix itself added fails
with the injection, and passes on clean 3.54.1.

## Use

    bin/apply.sh <id> <sqlite-3.54.1-tree>          # inject   (-R removes it)
    ./configure --all --geopoly --session --debug CFLAGS="-g -O0"
    make sqlite3 testfixture
    bin/check-repro.sh <id> ./sqlite3               # 1 = bug observed
    bin/check-test.sh  <id> ./testfixture <tree>    # 1 = an oracle case fails

The expected outputs come from that build (a debug build, so assert()s
fire); other build options can change error texts and plans.

## Per bug (bugs/<id>/)

- injection.patch: apply with patch -p1 to 3.54.1
- meta.json: fix commit and Fossil id, date, subject, report links, first
  release containing the fix, provenance, triage labels (kind, symptom,
  subsystem), injected and fix files, locality, anchor
- oracle.json: the upstream test cases that fail (and which the fix added)
- repro.sql or repro.sh, expected.txt, expected-status.txt, NOTES.md
- RATIONALE.md (adapted only)

The id is the first 12 hex digits of the fix's git commit in the official
mirror (https://github.com/sqlite/sqlite); fix_fossil is the Fossil check-in.
"""


def first_release(commit):
    r = E.git("describe", "--contains", "--match", "version-*", commit, check=False)
    m = re.match(r"(version-[\d.]+)", r.stdout.strip())
    return m.group(1) if m else None


def ephyra_fixes():
    """Fix commits of bugs ephyra found (its known-bugs registry)."""
    reg = Path(__import__("os").environ.get(
        "EPHYRA_REGISTRY", Path.home() / "ephyra-known-bugs.json"))
    out = {}
    if reg.exists():
        for b in json.load(open(reg))["bugs"]:
            ci = (b.get("fixed_in") or {}).get("checkin")
            if ci:
                hs = E.git("log", "--all", "--format=%H", f"--grep=^FossilOrigin-Name: {ci}").stdout.split()
                if len(set(hs)) == 1:
                    out[hs[0]] = b["name"]
    # Fix commits resolved by the trunk frontport (registry check-ins,
    # bisected fixes, and older bugs from the case study's STATUS.md).
    extra = Path.home() / "ephyra-fix-commits.json"
    if extra.exists():
        out.update(json.load(open(extra)))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(E.ROOT / "export" / "sqlite-etna-3.54.1"))
    ap.add_argument("--include-loose", action="store_true")
    a = ap.parse_args()
    out = Path(a.out)
    if out.exists():
        shutil.rmtree(out)
    (out / "bugs").mkdir(parents=True)
    (out / "bin").mkdir()

    cands = E.candidates()
    tri = E.latest("triage")
    base_runs = E.latest("base-runs", key="file")
    reps = E.latest("repro")
    eph = ephyra_fixes()
    entries = []

    def add(cid, tier_kind, patch, failing, added, extra):
        c = cands[cid]
        t = tri.get(cid, {})
        strict = bool(added) and extra.get("anchored", False)
        if not strict and not a.include_loose:
            return
        if t.get("kind") != "bug" or t.get("confidence") == "low":
            if not a.include_loose:
                return
        bid = cid[:12]
        d = out / "bugs" / bid
        d.mkdir()
        shutil.copy(patch, d / "injection.patch")
        inj_files = sorted(set(re.findall(r"^\+\+\+ b/(\S+)", patch.read_text(), re.M)))
        (d / "oracle.json").write_text(json.dumps({
            "cases": failing, "added_by_fix": added,
            "note": "upstream test cases (3.54.1's test/ files) that pass on clean 3.54.1 "
                    "and fail with the injection"}, indent=2) + "\n")
        r = reps.get(cid, {})
        repro_kind = None
        if r.get("result") == "confirmed":
            src = E.DATASET / "repro" / bid
            for f in ("repro.sql", "repro.sh", "expected.txt", "expected-status.txt", "NOTES.md"):
                if (src / f).exists():
                    shutil.copy(src / f, d / f)
            repro_kind = r.get("kind")
        rat = E.DATASET / "adapted-sonnet" / bid / "RATIONALE.md"
        if tier_kind == "adapted" and rat.exists():
            shutil.copy(rat, d / "RATIONALE.md")
        meta = {
            "id": bid, "fix_commit": cid, "fix_fossil": c.get("fossil"), "fix_date": c["date"][:10],
            "fix_subject": c["subject"], "reports": c.get("reports", []),
            "fixed_in_release": first_release(cid),
            "provenance": tier_kind, "tier": "strict" if strict else "loose",
            "kind": t.get("kind"), "symptom": t.get("symptom"), "subsystem": t.get("subsystem"),
            "triage_confidence": t.get("confidence"),
            "injected_files": inj_files, "fix_impl_files": c["impl_files"],
            "locality": ("subset" if set(inj_files) <= set(c["impl_files"]) else
                         "overlap" if set(inj_files) & set(c["impl_files"]) else "disjoint"),
            "oracle_test_files": sorted(failing), "repro": repro_kind,
            "found_by_ephyra": eph.get(cid),
            **{k: v for k, v in extra.items() if k != "anchored"},
        }
        (d / "meta.json").write_text(json.dumps(meta, indent=2) + "\n")
        entries.append(meta)

    for r in E.latest("verbatim").values():
        if r.get("result") == "confirmed":
            p = E.DATASET / "bugs" / r["id"][:12] / "injection.patch"
            if p.exists():
                add(r["id"], "verbatim", p, r["attempt"]["oracle_failing"], r.get("fix_added_failing") or {},
                    {"anchored": True, "apply_mode": r["attempt"].get("apply")})
    seen = {e["fix_commit"] for e in entries}
    for r in E.latest("adapt-sonnet").values():
        if r["id"] in seen or r.get("result") not in ("adapted_confirmed", "adapted_needs_review", "adapted_unanchored"):
            continue
        p = E.DATASET / "adapted-sonnet" / r["id"][:12] / "injection.patch"
        if p.exists() and r.get("attempt", {}).get("oracle_failing"):
            add(r["id"], "adapted", p, r["attempt"]["oracle_failing"], r.get("fix_added_failing") or {},
                {"anchored": r["result"] == "adapted_confirmed", "anchor": r.get("anchor"),
                 "signature_equivalence": r.get("signature_equivalence"), "model": r.get("model")})

    entries.sort(key=lambda e: e["fix_date"])
    with open(out / "index.jsonl", "w") as f:
        for e in entries:
            f.write(json.dumps(e, sort_keys=True) + "\n")
    for name, text in (("apply.sh", APPLY), ("check-repro.sh", CHECK_REPRO), ("check-test.sh", CHECK_TEST)):
        (out / "bin" / name).write_text(text)
        (out / "bin" / name).chmod(0o755)
    (out / "README.md").write_text(readme(entries))
    n = len(entries)
    by = lambda k: dict(sorted(__import__("collections").Counter(e[k] for e in entries).items(), key=lambda x: -x[1]))
    print(f"{n} bugs -> {out}")
    for k in ("tier", "provenance", "repro", "symptom", "locality"):
        print(f"  {k}: {by(k)}")
    print(f"  found_by_ephyra: {sum(1 for e in entries if e['found_by_ephyra'])}")


if __name__ == "__main__":
    main()
