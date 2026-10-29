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
    ok = {m.group(1) for m in re.finditer(r"^(\S+)\.\.\. *Ok\s*$", out, re.M)}
    failed = set()
    for m in re.finditer(r"Failures on these tests:\s*(.*)$", out, re.M):
        failed |= set(m.group(1).split())
    miss = [n for n in names if n not in ok - failed]
    if miss:
        bad[f] = miss
if bad:
    print("oracle cases failing:", json.dumps(bad)); sys.exit(1)
print("all oracle cases pass"); sys.exit(0)
PY
