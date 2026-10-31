#!/usr/bin/env python3
"""Export the CPython workload (ETNA_KIND=cpython): one directory per bug,
injected into CPython 3.15.2. Same layout as the Valkey workload.

  <out>/README.md, index.jsonl, marauder.toml
  <out>/patches/cpython_<id>.patch        the injections as Marauders variants
  <out>/bin/setup.sh DEST                clone v3.15.2 and add the variants
  <out>/bin/apply.sh BUG TREE [-R]       apply (or remove) one injection
  <out>/bin/check-repro.sh BUG TREE      run the reproducer with TREE's build
  <out>/bin/check-test.sh BUG TREE       run the upstream oracle test files
  <out>/bugs/<id>/ injection.patch meta.json oracle.json
                   repro.py expected.txt expected-status.txt NOTES.md
                   RATIONALE.md (adapted)

Only strict bugs: anchored, and a test case the fix added fails.

Usage:
  export_cpython.py [--out DIR]
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
# Apply a bug's injection to an unmodified CPython 3.15.2 source tree.
#   bin/apply.sh <bug-id> <cpython-3.15.2-tree> [-R]   (-R removes it again)
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
patch -p1 --batch ${3:-} -d "$2" < "$here/bugs/$1/injection.patch"
"""

SETUP = """\
#!/bin/bash
# Make a Marauders project out of CPython 3.15.2 and this workload's bugs.
#   bin/setup.sh <dest>
# Then, inside <dest>: marauders list|set|unset --path . [--variant cpython_<id>]
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
dest="${1:?usage: bin/setup.sh <dest>}"
if [ -e "$dest" ]; then echo "$dest already exists" >&2; exit 1; fi
git clone --quiet --depth 1 --branch v3.15.2 https://github.com/python/cpython.git "$dest"
rm -rf "$dest/.git"
cp -R "$here/patches" "$dest/patches"
cp "$here/marauder.toml" "$dest/marauder.toml"
echo "CPython 3.15.2 with $(ls "$dest/patches" | wc -l | tr -d ' ') bug variants in $dest"
"""

CHECK_REPRO = """\
#!/bin/bash
# Run a bug's reproducer with the interpreter built in TREE
# (./configure --with-pydebug && make) and compare it with clean 3.15.2.
# Exit 0: same as clean (bug not observed); 1: different (bug observed);
# 2: no reproducer for this bug.
#   bin/check-repro.sh <bug-id> <built-cpython-tree>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
d="$here/bugs/$1"; tree="$(cd "$2" && pwd)"
[ -f "$d/repro.py" ] || { echo "no standalone reproducer for $1 (see oracle.json)"; exit 2; }
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cd "$tmp"
out="$(PYTHONHASHSEED=0 PYTHONDONTWRITEBYTECODE=1 timeout --kill-after=5 30 "$tree/python" "$d/repro.py" 2>&1)"; st=$?
[ "$st" = 124 ] && st=timeout && out="$out
[timeout]"
# Signals: bash reports 128+N, the harness recorded -N.
[ "$st" != timeout ] && [ "$st" -gt 128 ] 2>/dev/null && st=$((128 - st))
if [ "$out" = "$(cat "$d/expected.txt")" ] && [ "$st" = "$(cat "$d/expected-status.txt")" ]; then
  echo "same as clean 3.15.2"; exit 0
fi
echo "differs from clean 3.15.2 (exit status $st):"; printf '%s\\n' "$out" | tail -20; exit 1
"""

CHECK_TEST = """\
#!/bin/bash
# Run a bug's upstream oracle test files with the interpreter built in TREE.
# Exit 1 when an oracle case fails (bug observed), 0 when all pass. Some
# tests are timing-sensitive: rerun a single failure before trusting it.
#   bin/check-test.sh <bug-id> <built-cpython-tree>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
tree="$(cd "$2" && pwd)"
python3 - "$here/bugs/$1/oracle.json" "$tree" <<'PY'
import json, re, subprocess, sys
oracle, tree = json.load(open(sys.argv[1])), sys.argv[2]
res = "all,-network,-urlfetch,-gui,-largefile,-audio,-cpu,-tzdata,-walltime"
bad = {}
for f, names in oracle["cases"].items():
    mod = re.sub(r"^test\\.", "", re.sub(r"(/__init__)?\\.py$", "", f[len("Lib/"):]).replace("/", "."))
    out = subprocess.run([tree + "/python", "-m", "test", "-v", "-u", res, mod], cwd=tree,
                         capture_output=True, timeout=1800).stdout.decode("utf-8", "replace")
    ok = {m.group(1) for m in re.finditer(r"^\\w+ \\(([\\w.]+)\\)(?:\\n.*?)?\\s\\.\\.\\.\\sok\\s*$", out, re.M)}
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
ignore = ["Lib/test", "Doc", "Tools", "Misc", "PCbuild", "Mac", "Android", "iOS", "Platforms"]
use_gitignore = false
custom_languages = []
"""


def readme(entries, target):
    c = lambda k: ", ".join(f"{v} {k2}" for k2, v in collections.Counter(e[k] for e in entries).most_common())
    n = len(entries)
    nrep = sum(1 for e in entries if e["repro"])
    lang = collections.Counter("C" if all(f.endswith((".c", ".h")) for f in e["injected_files"]) else
                               "Python" if all(f.endswith(".py") for f in e["injected_files"]) else "C and Python"
                               for e in entries)
    return f"""# CPython 3.15.2 workload

{n} historical CPython bugs, each re-injected into **CPython 3.15.2** (git
{target[:12]}) as a patch, for evaluating testing tools. Every bug comes from an
upstream fix commit (gh-/bpo- referenced, 2017 onwards); the injection brings
back the behaviour that commit fixed.

- Provenance: {c("provenance")}
  - verbatim: the upstream fix's implementation hunks, reversed on 3.15.2
  - adapted: re-expressed on 3.15.2 by a Claude agent (claude-sonnet-5-5)
    where the old hunks no longer apply; RATIONALE.md maps each hunk to the
    fix. Anchored: at the original fix commit, the pre-fix code fails the
    same test cases. The adapted tier covers fixes from 2023 onwards.
- Injected code: {", ".join(f"{v} {k}" for k, v in lang.most_common())}
- Symptoms: {c("symptom")}
- Standalone reproducers: {nrep} of {n} (repro.py, run with the built interpreter)
- Locality: {c("locality")}

Every bug is "strict": a test case the upstream fix itself added fails with
the injection, and passes on clean 3.15.2 (in both of two runs).

## Use

    bin/setup.sh /tmp/cpython-3.15.2                  # 3.15.2 + Marauders variants
    cd /tmp/cpython-3.15.2
    marauders set --path . --variant cpython_<id>     # or: bin/apply.sh <id> <tree>
    ./configure --with-pydebug && make -j
    bin/check-repro.sh <id> /tmp/cpython-3.15.2       # 1 = bug observed
    bin/check-test.sh  <id> /tmp/cpython-3.15.2       # 1 = an oracle case fails
    marauders unset --path . --variant cpython_<id>

The expected outputs come from a `--with-pydebug` build (C assert()s on).
For bugs in Lib/*.py, no rebuild is needed after set/unset.

## Per bug (bugs/<id>/)

- injection.patch (also patches/cpython_<id>.patch)
- meta.json: fix commit, date, subject, gh-/bpo- references, first release
  containing the fix, provenance, labels (kind, symptom, subsystem),
  injected and fix files, locality, anchor
- oracle.json: the upstream test cases (unittest ids) that fail, and which
  the fix added
- repro.py, expected.txt, expected-status.txt, NOTES.md
- RATIONALE.md (adapted only)

The id is the first 12 hex digits of the fix's commit in
https://github.com/python/cpython.
"""


def _scrub(p):
    """Agents' notes sometimes mention their scratch paths; keep the prose,
    drop the machine."""
    if p.exists():
        t = p.read_text(errors="replace")
        for local, label in ((str(E.WORK), "<work>"), (str(E.ROOT), "<root>"), (str(Path.home()), "~")):
            t = t.replace(local, label)
        p.write_text(t)


def _machine_local(d):
    """A reproducer whose script or expected output mentions a path on the
    mining machine (tracebacks print the interpreter's Lib/ path) would not
    match anywhere else; such bugs keep only their test oracle."""
    local = (str(Path.home()), str(E.WORK), str(E.ROOT))
    for f in ("repro.py", "expected.txt"):        # the shipped files
        p = d / f
        if p.exists() and any(x in p.read_text(errors="replace") for x in local):
            return True
    return False


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(E.ROOT / "export" / "cpython"))
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
        shutil.copy(patch, out / "patches" / f"cpython_{bid}.patch")
        inj_files = sorted(set(re.findall(r"^\+\+\+ b/(\S+)", patch.read_text(), re.M)))
        (d / "oracle.json").write_text(json.dumps({
            "cases": failing, "added_by_fix": added,
            "note": "upstream test cases (3.15.2's Lib/test/) that pass on clean 3.15.2 in two runs "
                    "and fail with the injection in two runs"}, indent=2) + "\n")
        r = reps.get(cid, {})
        if r.get("result") == "confirmed" and not _machine_local(E.DATASET / "repro" / bid):
            for f in ("repro.py", "expected.txt", "expected-status.txt", "NOTES.md"):
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
            "fix_is_merge": c.get("merge", False), "reports": c.get("reports", []),
            "fixed_in_release": first_release(cid), "provenance": prov, "tier": "strict",
            "kind": t.get("kind"), "symptom": t.get("symptom"), "subsystem": t.get("subsystem"),
            "triage_confidence": t.get("confidence"),
            "injected_files": inj_files, "fix_impl_files": c["impl_files"],
            "locality": ("subset" if set(inj_files) <= set(c["impl_files"]) else
                         "overlap" if set(inj_files) & set(c["impl_files"]) else "disjoint"),
            "oracle_test_files": sorted(failing),
            "repro": "py" if r.get("result") == "confirmed" else None, **extra}
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
