"""Headless Claude agents (adapted injections and reproducers), sandboxed to their slot directory."""
import os, json, subprocess, time, shutil, hashlib
from gate import *
from z3lab import Z3TEST

MODEL = "claude-sonnet-5-5"
SPEND_FILE = os.path.join(DATA, "spend.jsonl")


def cred_ok():
    return subprocess.run(os.environ.get("ETNA_CRED_CHECK", "true"), shell=True).returncode == 0


def spent(stage=None):
    if not os.path.exists(SPEND_FILE):
        return 0.0
    t = 0.0
    for l in open(SPEND_FILE):
        d = json.loads(l)
        if stage is None or d["stage"] == stage:
            t += d["usd"]
    return t


def record_spend(stage, sha, usd, extra=None):
    with open(SPEND_FILE, "a") as f:
        f.write(json.dumps(dict(stage=stage, sha=sha, usd=usd, t=time.time(), **(extra or {}))) + "\n")


def sandbox_settings(workdir):
    return {
        "sandbox": {"enabled": True, "autoAllowBashIfSandboxed": True, "allowUnsandboxedCommands": False,
                    "network": {"allowLocalBinding": True, "allowedDomains": []}},
        "permissions": {"allow": ["Bash", "Read", "Glob", "Grep", f"Edit({workdir}/**)", f"Write({workdir}/**)"],
                        "deny": ["WebFetch", "WebSearch", f"Edit({BASE}/**)", f"Write({BASE}/**)"]},
    }


AGENT_BUDGET = {"claude-sonnet-5-5": 4.0, "claude-opus-5-5": 8.0}


def run_agent(workdir, prompt, model=MODEL, max_turns=80, timeout=3600, stage="agent", sha=""):
    """Run one headless agent. Returns dict(ok, usd, result, error, retryable)."""
    for _ in range(30):
        if cred_ok():
            break
        time.sleep(60)
    else:
        return dict(ok=False, retryable=True, error="credential helper failing", usd=0)
    sfile = os.path.join(workdir, ".agent-settings.json")
    json.dump(sandbox_settings(workdir), open(sfile, "w"))
    out = os.path.join(workdir, ".agent-out.json")
    t0 = time.time()
    with open(out, "w") as fo, open(os.path.join(workdir, ".agent-err.txt"), "w") as fe:
        p = subprocess.Popen(["claude", "-p", "--model", model, "--settings", sfile, "--output-format", "json",
                              "--max-turns", str(max_turns),
                              "--max-budget-usd", str(AGENT_BUDGET.get(model, 4.0))], cwd=workdir, stdin=subprocess.PIPE, stdout=fo,
                             stderr=fe, start_new_session=True, env=dict(os.environ, TMPDIR=os.path.join(workdir, ".tmp")))
        os.makedirs(os.path.join(workdir, ".tmp"), exist_ok=True)
        try:
            p.communicate(prompt.encode(), timeout=timeout)
        except subprocess.TimeoutExpired:
            pass
        try:
            os.killpg(p.pid, 9)
        except ProcessLookupError:
            pass
        p.wait()
    kill_leftovers(workdir)
    secs = time.time() - t0
    try:
        d = json.load(open(out))
    except Exception:
        err = open(os.path.join(workdir, ".agent-err.txt"), errors="replace").read()[-2000:]
        # spend unknown: book the per-agent budget cap as a conservative upper bound
        ub = AGENT_BUDGET.get(model, 4.0)
        record_spend(stage, sha, ub, dict(model=model, estimated_upper_bound=True, secs=round(secs)))
        return dict(ok=False, retryable=True, error="no json output (timeout or crash): " + err, usd=ub,
                    usd_estimated=True, secs=secs)
    usd = d.get("total_cost_usd", 0) or 0
    record_spend(stage, sha, usd, dict(model=model, turns=d.get("num_turns"), secs=round(secs)))
    res = d.get("result", "") or ""
    if d.get("is_error") and d.get("subtype") not in ("error_max_turns",):
        api = any(k in res.lower() for k in ("api error", "overloaded", "rate limit", "authentication", "credential", "401", "529", "500"))
        return dict(ok=False, retryable=api, error=f"{d.get('subtype')}: {res[:500]}", usd=usd, secs=secs)
    return dict(ok=True, usd=usd, result=res[-4000:], turns=d.get("num_turns"), subtype=d.get("subtype"), secs=secs)


def kill_leftovers(workdir):
    """Kill processes left behind by an agent (e.g. bwrap sandboxes start their own session, so a
    process-group kill misses them). Selected by cwd or cmdline inside workdir; never ourselves."""
    me = os.getpid()
    killed = []
    for pid in os.listdir("/proc"):
        if not pid.isdigit() or int(pid) == me:
            continue
        try:
            cwd = os.readlink(f"/proc/{pid}/cwd")
            cmd = open(f"/proc/{pid}/cmdline", "rb").read().decode(errors="replace")
        except OSError:
            continue
        if cwd.startswith(workdir) or (workdir + "/") in cmd:
            try:
                os.kill(int(pid), 9); killed.append(int(pid))
            except OSError:
                pass
    return killed


def cmake_cache_hash(build):
    p = os.path.join(build, "CMakeCache.txt")
    return hashlib.sha256(open(p, "rb").read()).hexdigest() if os.path.exists(p) else None


CHECK_SH = """#!/bin/bash
# Build the tree and run the oracle unit tests. Usage: ./check.sh [unit ...]
cd "$(dirname "$0")"
ulimit -v 8000000
export PYTHONDONTWRITEBYTECODE=1
exec 9>build/.etna-check.lock; flock 9   # one check at a time per slot (builds can be slow under load)
ninja -C build -j{jobs} z3 test-z3 > .build.log 2>&1 || {{ echo "BUILD FAILED"; grep -m 20 -E "error|Error" .build.log; exit 2; }}
echo "BUILD OK"
units="${{@:-{units}}}"
for u in $units; do
  d=$(mktemp -d .tmp/run.XXXX)
  case $u in
  z3test:*)
    f={z3test}/${{u#z3test:}}; cp $f $d/in.smt2
    ( cd $d && timeout -s KILL 120 setsid ../../build/z3 model_validate=true in.smt2 < /dev/null > out.txt 2>&1 ); rc=$?
    if [ $rc -le 1 -o $rc -eq 105 ] && cmp -s $d/out.txt ${{f%.smt2}}.expected.out; then echo "PASS $u"; else echo "FAIL $u (rc=$rc)"; diff ${{f%.smt2}}.expected.out $d/out.txt | head -n 15 | sed 's/^/    /'; fi ;;
  *)
    ( cd $d && timeout -s KILL {timeout} setsid ../../build/test-z3 $u < /dev/null > out.txt 2>&1 ); rc=$?
    if [ $rc -eq 0 ] && grep -qx PASS $d/out.txt; then echo "PASS $u"; else echo "FAIL $u (rc=$rc)"; tail -n 15 $d/out.txt | sed 's/^/    /'; fi ;;
  esac
  rm -rf $d
done
"""
