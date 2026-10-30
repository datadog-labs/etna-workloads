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
    unit = re.sub(r"^tests/|\.tcl$", "", f)
    out = subprocess.run(["./runtest", "--single", unit, "--clients", "1"], cwd=tree,
                         capture_output=True, timeout=1800).stdout.decode("utf-8", "replace")
    out = re.sub(r"\x1b\[[0-9;]*m", "", out)
    ok = {m.group(1) for m in re.finditer(r"^\[ok\]: (.*) \(\d+ ms\)\s*$", out, re.M)}
    miss = [n for n in names if n not in ok]
    if miss:
        bad[f] = miss
if bad:
    print("oracle cases failing:", json.dumps(bad)); sys.exit(1)
print("all oracle cases pass"); sys.exit(0)
PY
