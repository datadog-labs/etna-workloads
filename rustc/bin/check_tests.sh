#!/bin/bash
# Rebuild the compiler in DIR (whatever is applied) and run BUG's oracle cases.
# Prints BUG PRESENT (exit 1) if any of the bug's failing cases fails, CLEAN (exit 0) otherwise.
# usage: bin/check_tests.sh DIR BUG
set -u
HERE=$(cd "$(dirname "$0")/.." && pwd)
DIR=${1:?DIR}; BUG=${2:?BUG}
cd "$DIR" && ./x build --stage 1 --keep-stage-std 1 compiler/rustc > /dev/null 2>&1 || { echo "BUILD FAILED"; exit 2; }
FILES=$(python3 -c "import json,sys; o=json.load(open(sys.argv[1])); print(' '.join(sorted({c.split('#')[0] for c in o['oracle']})))" "$HERE/bugs/$BUG/oracle.json")
LOG=$(mktemp "${TMPDIR:-/tmp}/check_tests.XXXXXX")   # never write into the workload directory
trap 'rm -f "$LOG"' EXIT
./x test --stage 1 --keep-stage-std 1 --force-rerun --no-fail-fast $FILES > "$LOG" 2>&1
python3 - "$HERE/bugs/$BUG/oracle.json" "$LOG" <<'PY'
import json, re, sys
o = json.load(open(sys.argv[1]))
seen = {}
for line in open(sys.argv[2], errors="replace"):
    line = re.sub(r"\x1b\[[0-9;?]*[A-Za-z]", "", line)
    m = re.match(r"^test \[[\w-]+\] (\S+?) \.\.\. (ok|FAILED|ignored|timeout)", line)
    if m:
        seen[m.group(1)] = m.group(2)
bad = [c for c in o["failing"] if seen.get(c) in ("FAILED", "timeout")]
missing = [c for c in o["oracle"] if c not in seen]
for c in o["oracle"]:
    print(f"  {seen.get(c, 'not run'):8} {c}")
if missing:
    print(f"warning: {len(missing)} oracle cases not reported")
print("BUG PRESENT" if bad else "CLEAN")
sys.exit(1 if bad else 0)
PY
