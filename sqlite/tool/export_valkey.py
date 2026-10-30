#!/usr/bin/env python3
"""Export the Valkey workload (ETNA_KIND=valkey): one directory per bug,
injected into Valkey 9.0.7. Same layout as export.py's SQLite workload.

  <out>/README.md, index.jsonl, marauder.toml
  <out>/patches/valkey_<id>.patch        the injections as Marauders variants
  <out>/bin/setup.sh DEST                clone 9.0.7 and add the variants
  <out>/bin/apply.sh BUG TREE [-R]       apply (or remove) one injection
  <out>/bin/check-repro.sh BUG TREE      run the reproducer with TREE's build
  <out>/bin/check-test.sh BUG TREE       run the upstream oracle test files
  <out>/bugs/<id>/ injection.patch meta.json oracle.json
                   repro.sh expected.txt expected-status.txt NOTES.md
                   RATIONALE.md (adapted)

Only strict bugs: anchored, and a test case the fix added fails.

Usage:
  export_valkey.py [--out DIR]
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
from export import first_release  # noqa: E402

APPLY = """\
#!/bin/bash
# Apply a bug's injection to an unmodified Valkey 9.0.7 source tree.
#   bin/apply.sh <bug-id> <valkey-9.0.7-tree> [-R]   (-R removes it again)
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
patch -p1 --batch ${3:-} -d "$2" < "$here/bugs/$1/injection.patch"
"""

SETUP = """\
#!/bin/bash
# Make a Marauders project out of Valkey 9.0.7 and this workload's bugs.
#   bin/setup.sh <dest>
# Then, inside <dest>: marauders list|set|unset --path . [--variant valkey_<id>]
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
dest="${1:?usage: bin/setup.sh <dest>}"
if [ -e "$dest" ]; then echo "$dest already exists" >&2; exit 1; fi
git clone --quiet --depth 1 --branch 9.0.7 https://github.com/valkey-io/valkey.git "$dest"
rm -rf "$dest/.git"
cp -R "$here/patches" "$dest/patches"
cp "$here/marauder.toml" "$dest/marauder.toml"
echo "Valkey 9.0.7 with $(ls "$dest/patches" | wc -l | tr -d ' ') bug variants in $dest"
"""

CHECK_REPRO = """\
#!/bin/bash
# Run a bug's reproducer against the build in TREE (make MALLOC=libc there
# first) and compare it with clean 9.0.7. Exit 0: same as clean (bug not
# observed); 1: different (bug observed); 2: no reproducer for this bug.
#   bin/check-repro.sh <bug-id> <built-valkey-tree>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
d="$here/bugs/$1"; tree="$(cd "$2" && pwd)"
[ -f "$d/repro.sh" ] || { echo "no standalone reproducer for $1 (see oracle.json)"; exit 2; }
port=$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1])')
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cd "$tmp"
out="$(VALKEY_SERVER="$tree/src/valkey-server" VALKEY_CLI="$tree/src/valkey-cli" PORT=$port \\
       timeout --kill-after=5 30 setsid bash "$d/repro.sh" 2>&1)"; st=$?
[ "$st" = 124 ] && st=timeout && out="$out
[timeout]"
pkill -f -- "--port $port" 2>/dev/null
if [ "$out" = "$(cat "$d/expected.txt")" ] && [ "$st" = "$(cat "$d/expected-status.txt")" ]; then
  echo "same as clean 9.0.7"; exit 0
fi
echo "differs from clean 9.0.7 (exit status $st):"; printf '%s\\n' "$out" | tail -20; exit 1
"""

CHECK_TEST = """\
#!/bin/bash
# Run a bug's upstream oracle test files in a built tree (make MALLOC=libc).
# Exit 1 when an oracle case fails (bug observed), 0 when all pass. Some
# Valkey tests are timing-sensitive: rerun a single failure before trusting it.
#   bin/check-test.sh <bug-id> <built-valkey-tree>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
tree="$(cd "$2" && pwd)"
python3 - "$here/bugs/$1/oracle.json" "$tree" <<'PY'
import json, re, subprocess, sys
oracle, tree = json.load(open(sys.argv[1])), sys.argv[2]
bad = {}
for f, names in oracle["cases"].items():
    unit = re.sub(r"^tests/|\\.tcl$", "", f)
    out = subprocess.run(["./runtest", "--single", unit, "--clients", "1"], cwd=tree,
                         capture_output=True, timeout=1800).stdout.decode("utf-8", "replace")
    out = re.sub(r"\\x1b\\[[0-9;]*m", "", out)
    ok = {m.group(1) for m in re.finditer(r"^\\[ok\\]: (.*) \\(\\d+ ms\\)\\s*$", out, re.M)}
    miss = [n for n in names if n not in ok]
    if miss:
        bad[f] = miss
if bad:
    print("oracle cases failing:", json.dumps(bad)); sys.exit(1)
print("all oracle cases pass"); sys.exit(0)
PY
"""

MARAUDER = """\
languages = []
ignore = ["tests", "deps", "utils"]
use_gitignore = false
custom_languages = []
"""


def readme(entries, target):
    c = lambda k: ", ".join(f"{v} {k2}" for k2, v in collections.Counter(e[k] for e in entries).most_common())
    n = len(entries)
    nrep = sum(1 for e in entries if e["repro"])
    return f"""# Valkey 9.0.7 workload

{n} historical Valkey/Redis bugs, each re-injected into **Valkey 9.0.7** (git
{target[:12]}) as a patch, for evaluating testing tools. Every bug comes from an
upstream fix commit (Valkey's history includes Redis up to the 2024 fork);
the injection brings back the behaviour that commit fixed.

- Provenance: {c("provenance")}
  - verbatim: the upstream fix's implementation hunks, reversed on 9.0.7
  - adapted: re-expressed on 9.0.7 by a Claude agent (claude-sonnet-5-5),
    where the old hunks no longer apply (much of the pre-2024 code was
    renamed); RATIONALE.md maps each hunk to the fix. Anchored: at the
    original fix commit, the pre-fix code fails the same test cases.
- Symptoms: {c("symptom")}
- Standalone reproducers: {nrep} of {n} (repro.sh: starts a server, drives it with the CLI)
- Locality: {c("locality")}

Every bug is "strict": a test case the upstream fix itself added fails with
the injection, and passes on clean 9.0.7 (in both of two runs).

## Use

    bin/setup.sh /tmp/valkey-9.0.7                   # 9.0.7 + Marauders variants
    cd /tmp/valkey-9.0.7
    marauders set --path . --variant valkey_<id>     # or: bin/apply.sh <id> <tree>
    make MALLOC=libc
    bin/check-repro.sh <id> /tmp/valkey-9.0.7        # 1 = bug observed
    bin/check-test.sh  <id> /tmp/valkey-9.0.7        # 1 = an oracle case fails
    marauders unset --path . --variant valkey_<id>

The expected outputs come from `make MALLOC=libc OPTIMIZATION=-O1`.

## Per bug (bugs/<id>/)

- injection.patch (also patches/valkey_<id>.patch)
- meta.json: fix commit, date, subject, PR/issue references, first release
  containing the fix, provenance, labels (kind, symptom, subsystem),
  injected and fix files, locality, anchor
- oracle.json: the upstream test cases that fail (and which the fix added)
- repro.sh, expected.txt, expected-status.txt, NOTES.md
- RATIONALE.md (adapted only)

The id is the first 12 hex digits of the fix's commit in
https://github.com/valkey-io/valkey.
"""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(E.ROOT / "export" / "valkey"))
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
        shutil.copy(patch, out / "patches" / f"valkey_{bid}.patch")
        inj_files = sorted(set(re.findall(r"^\+\+\+ b/(\S+)", patch.read_text(), re.M)))
        (d / "oracle.json").write_text(json.dumps({
            "cases": failing, "added_by_fix": added,
            "note": "upstream test cases (9.0.7's tests/) that pass on clean 9.0.7 in two runs "
                    "and fail with the injection in two runs"}, indent=2) + "\n")
        r = reps.get(cid, {})
        if r.get("result") == "confirmed":
            for f in ("repro.sh", "expected.txt", "expected-status.txt", "NOTES.md"):
                src = E.DATASET / "repro" / bid / f
                if src.exists():
                    shutil.copy(src, d / f)
        rat = E.DATASET / "adapted-sonnet" / bid / "RATIONALE.md"
        if prov == "adapted" and rat.exists():
            shutil.copy(rat, d / "RATIONALE.md")
        meta = {
            "id": bid, "fix_commit": cid, "fix_date": c["date"][:10], "fix_subject": c["subject"],
            "fix_is_merge": c.get("merge", False), "reports": c.get("reports", []),
            "fixed_in_release": first_release(cid), "provenance": prov, "tier": "strict",
            "kind": t.get("kind"), "symptom": t.get("symptom"), "subsystem": t.get("subsystem"),
            "triage_confidence": t.get("confidence"),
            "injected_files": inj_files, "fix_impl_files": c["impl_files"],
            "locality": ("subset" if set(inj_files) <= set(c["impl_files"]) else
                         "overlap" if set(inj_files) & set(c["impl_files"]) else "disjoint"),
            "oracle_test_files": sorted(failing),
            "repro": "sh" if r.get("result") == "confirmed" else None, **extra}
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
