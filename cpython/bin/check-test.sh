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
    mod = re.sub(r"^test\.", "", re.sub(r"(/__init__)?\.py$", "", f[len("Lib/"):]).replace("/", "."))
    out = subprocess.run([tree + "/python", "-m", "test", "-v", "-u", res, mod], cwd=tree,
                         capture_output=True, timeout=1800).stdout.decode("utf-8", "replace")
    ok = {m.group(1) for m in re.finditer(r"^\w+ \(([\w.]+)\)(?:\n.*?)?\s\.\.\.\sok\s*$", out, re.M)}
    miss = [n for n in names if n not in ok]
    if miss:
        bad[f] = miss
if bad:
    print("oracle cases failing:", json.dumps(bad)); sys.exit(1)
print("all oracle cases pass"); sys.exit(0)
PY
