#!/bin/bash
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
