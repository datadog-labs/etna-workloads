#!/usr/bin/env python3
"""Export the Go compiler workload (ETNA_KIND=go): one directory per bug,
injected into Go 1.27.3. Same layout as the other workloads.

  <out>/README.md, index.jsonl, marauder.toml
  <out>/patches/go_<id>.patch        the injections as Marauders variants
  <out>/bin/setup.sh DEST                clone go1.27.3 and add the variants
  <out>/bin/apply.sh BUG TREE [-R]       apply (or remove) one injection
  <out>/bin/check-repro.sh BUG TREE      run the reproducer with TREE's build
  <out>/bin/check-test.sh BUG TREE       run the upstream oracle test files
  <out>/bugs/<id>/ injection.patch meta.json oracle.json
                   repro.go|repro.sh expected.txt expected-status.txt NOTES.md
                   RATIONALE.md (adapted)

Only strict bugs: anchored, and a test case the fix added fails.

Usage:
  export_go.py [--out DIR]
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
# Apply a bug's injection to an unmodified Go 1.27.3 source tree.
#   bin/apply.sh <bug-id> <go-1.27.3-tree> [-R]   (-R removes it again)
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
patch -p1 --batch ${3:-} -d "$2" < "$here/bugs/$1/injection.patch"
"""

SETUP = """\
#!/bin/bash
# Make a Marauders project out of Go 1.27.3 and this workload's bugs.
#   bin/setup.sh <dest>
# Then build the toolchain (cd src && GOROOT_BOOTSTRAP=<go >= 1.24> ./make.bash)
# and use marauders list|set|unset --path . [--variant go_<id>]; after each
# set/unset, rebuild the compiler with bin/go install cmd/compile.
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
dest="${1:?usage: bin/setup.sh <dest>}"
if [ -e "$dest" ]; then echo "$dest already exists" >&2; exit 1; fi
git clone --quiet --depth 1 --branch go1.27.3 https://github.com/golang/go.git "$dest"
rm -rf "$dest/.git"
cp -R "$here/patches" "$dest/patches"
cp "$here/marauder.toml" "$dest/marauder.toml"
echo "Go 1.27.3 with $(ls "$dest/patches" | wc -l | tr -d ' ') bug variants in $dest"
"""

CHECK_REPRO = r"""#!/bin/bash
# Run a bug's reproducer with the toolchain in GOROOT and compare it with
# clean 1.27.3. Toolchain, work-directory and go temporary paths are replaced
# with placeholders first, as when the expected output was recorded.
# Exit 0: same as clean (bug not observed); 1: different (bug observed);
# 2: no reproducer for this bug.
#   bin/check-repro.sh <bug-id> <goroot>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
d="$here/bugs/$1"; goroot="$(cd "$2" && pwd)"
[ -f "$d/repro.go" ] || [ -f "$d/repro.sh" ] || { echo "no standalone reproducer for $1 (see oracle.json)"; exit 2; }
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cp "$d"/repro.go "$d"/repro.sh "$tmp"/ 2>/dev/null
cd "$tmp"
# One build cache per compiler binary (a release toolchain keys the cache on
# its version string, so clean and injected compilers would share entries).
cid="$(cat "$goroot"/pkg/tool/*/compile | sha256sum | cut -c1-16)"
export GO="$goroot/bin/go" PATH="$goroot/bin:$PATH" GOTOOLCHAIN=local GOFLAGS= GOCACHE="$goroot/.etna-gocache/$cid" GOPATH="$tmp/.gopath"
if [ -f repro.sh ]; then out="$(timeout --kill-after=5 120 bash repro.sh 2>&1)"; st=$?
else out="$(timeout --kill-after=5 120 "$GO" run -trimpath repro.go 2>&1)"; st=$?; fi
[ "$st" = 124 ] && st=timeout && out="$out
[timeout]"
[ "$st" != timeout ] && [ "$st" -gt 128 ] 2>/dev/null && st=$((128 - st))
out="$(printf '%s' "$out" | sed -e "s#$goroot#\$GOROOT#g" -e "s#$tmp#\$WORK#g" -E -e 's#/tmp/go-build[0-9]+#$TMP#g')"
if [ "$out" = "$(cat "$d/expected.txt")" ] && [ "$st" = "$(cat "$d/expected-status.txt")" ]; then
  echo "same as clean 1.27.3"; exit 0
fi
echo "differs from clean 1.27.3 (exit status $st):"; printf '%s\n' "$out" | tail -20; exit 1
"""

CHECK_TEST = r"""#!/bin/bash
# Run a bug's upstream oracle tests with the toolchain in GOROOT: test/
# programs through cmd/internal/testdir, compiler packages with go test.
# Exit 1 when an oracle case fails (bug observed), 0 when all pass.
#   bin/check-test.sh <bug-id> <goroot>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
goroot="$(cd "$2" && pwd)"
python3 - "$here/bugs/$1/oracle.json" "$goroot" <<'PY'
import glob, hashlib, json, os, re, subprocess, sys
oracle, goroot = json.load(open(sys.argv[1])), sys.argv[2]
# One build cache per compiler binary (see check-repro.sh).
cid = hashlib.sha256(open(glob.glob(goroot + "/pkg/tool/*/compile")[0], "rb").read()).hexdigest()[:16]
env = {**os.environ, "GOTOOLCHAIN": "local", "GOFLAGS": "", "GOCACHE": f"{goroot}/.etna-gocache/{cid}"}
bad = {}
for unit, names in oracle["cases"].items():
    if unit.startswith("pkg:"):
        cmd = [goroot + "/bin/go", "test", unit[4:], "-v", "-count=1"]
    else:
        cmd = [goroot + "/bin/go", "test", "cmd/internal/testdir", "-v", "-count=1",
               "-run", "^Test/" + re.escape(unit[len("test/"):]) + "$"]
    out = subprocess.run(cmd, cwd=goroot + "/src", env=env, capture_output=True, timeout=3600).stdout.decode("utf-8", "replace")
    ok = {m.group(2) for m in re.finditer(r"^\s*--- (PASS|FAIL|SKIP): (\S+)", out, re.M) if m.group(1) == "PASS"}
    miss = [n for n in names if n not in ok]
    if miss:
        bad[unit] = miss
if bad:
    print("oracle cases failing:", json.dumps(bad)); sys.exit(1)
print("all oracle cases pass"); sys.exit(0)
PY
"""

MARAUDER = """\
languages = []
ignore = ["test", "misc", "doc", "api", "lib"]
use_gitignore = false
custom_languages = []
"""


def readme(entries, target):
    c = lambda k: ", ".join(f"{v} {k2}" for k2, v in collections.Counter(e[k] for e in entries).most_common())
    n = len(entries)
    nrep = sum(1 for e in entries if e["repro"])
    years = collections.Counter(e["fix_date"][:4] for e in entries)
    return f"""# Go 1.27.3 compiler workload

{n} historical bugs in the Go compiler (cmd/compile), each re-injected into
**Go 1.27.3** (git {target[:12]}) as a patch, for evaluating testing tools.
Every bug comes from an upstream fix commit with a "Fixes #N" line; the
injection brings back the behaviour that commit fixed.

- Provenance: {c("provenance")}
  - verbatim: the upstream fix's implementation hunks, reversed on 1.27.3
  - adapted: re-expressed on 1.27.3 by a Claude agent (claude-sonnet-5-5)
    where the old hunks no longer apply; RATIONALE.md maps each hunk to the
    fix. Anchored: at the original fix commit, the pre-fix code fails the
    same test cases. The adapted tier covers fixes from 2020 onwards.
- Fix years: {", ".join(f"{y}: {years[y]}" for y in sorted(years))}
- Symptoms: {c("symptom")}
- Standalone reproducers: {nrep} of {n} (repro.go or repro.sh)
- Locality: {c("locality")}

Every bug is "strict": a test case the upstream fix itself added fails with
the injection, and passes on clean 1.27.3 (in both of two runs). Only the
compiler is in scope (not the runtime or standard library), and
architecture-specific fixes appear only when they are observable on amd64.

## Use

    bin/setup.sh /tmp/go-1.27.3                   # 1.27.3 + Marauders variants
    (cd /tmp/go-1.27.3/src && GOROOT_BOOTSTRAP=<go >= 1.24> ./make.bash)
    cd /tmp/go-1.27.3
    marauders set --path . --variant go_<id>      # or: bin/apply.sh <id> <tree>
    bin/go install cmd/compile
    bin/check-repro.sh <id> /tmp/go-1.27.3        # 1 = bug observed
    bin/check-test.sh  <id> /tmp/go-1.27.3        # 1 = an oracle case fails
    marauders unset --path . --variant go_<id> && bin/go install cmd/compile

A release toolchain identifies its compiler by version, not by content, so a
shared build cache would mix clean and injected compilers. The check scripts
use one cache per compiler binary, under the GOROOT (.etna-gocache/<hash>);
delete that directory to reclaim space. Your own go commands with an injected
compiler should use a separate GOCACHE as well.

## Per bug (bugs/<id>/)

- injection.patch (also patches/go_<id>.patch)
- meta.json: fix commit, date, subject, issue references, first release
  containing the fix, provenance, labels (kind, symptom, subsystem),
  injected and fix files, locality, anchor
- oracle.json: the upstream tests that fail (test/ programs as
  Test/<path>, compiler package tests as pkg:<import path>), and which the
  fix added
- repro.go or repro.sh, expected.txt, expected-status.txt, NOTES.md
- RATIONALE.md (adapted only)

The id is the first 12 hex digits of the fix's commit in
https://github.com/golang/go.
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
    for f in ("repro.go", "repro.sh", "expected.txt"):        # the shipped files
        p = d / f
        if p.exists() and any(x in p.read_text(errors="replace") for x in local):
            return True
    return False


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(E.ROOT / "export" / "go"))
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
        shutil.copy(patch, out / "patches" / f"go_{bid}.patch")
        inj_files = sorted(set(re.findall(r"^\+\+\+ b/(\S+)", patch.read_text(), re.M)))
        (d / "oracle.json").write_text(json.dumps({
            "cases": failing, "added_by_fix": added,
            "note": "upstream tests (1.27.3's test/ programs and compiler package tests) that pass on clean 1.27.3 in two runs "
                    "and fail with the injection in two runs"}, indent=2) + "\n")
        r = reps.get(cid, {})
        if r.get("result") == "confirmed" and not _machine_local(E.DATASET / "repro" / bid):
            for f in ("repro.go", "repro.sh", "expected.txt", "expected-status.txt", "NOTES.md"):
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
