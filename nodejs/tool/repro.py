#!/usr/bin/env python3
"""Reproducers: an agent writes a standalone script; the harness verifies it.

Agent phase: the agent slot gets the bug's injection applied and built; the agent
also gets the clean release binary (read-only base build).  It writes repro.js
(run as `<node> repro.js`) or repro.sh (run as `bash repro.sh <node>`).

Harness verification (never the agent's word), in fresh empty directories:
  clean    = read-only base build binary, 3 runs: identical normalised output+exit
  injected = gate slot with the injection applied and built, 2 runs: both differ from clean
Outputs are normalised (binary path, run dir, slot paths -> placeholders); a reproducer
whose clean/injected difference is only a version or path string is rejected.
"""
import argparse, json, os, re, shutil, subprocess, sys, tempfile, threading, queue, traceback
import agents, gate, llm, slot as S

W = S.W
CLEAN_NODE = os.path.join(W, "base/out/Release/node")
RUN_TIMEOUT = 60

PROMPT = """You are helping build a benchmark of real, historical Node.js bugs. A known bug has been
re-introduced into the Node.js v26.13.0 tree in your current directory, which is built
(binary: ./out/Release/node). A clean, unmodified build of the same release is at
{clean} (read-only).

## The bug
Upstream fix {sha}: {subject}
{message}

The re-introduced change (diff from the clean release to this tree):
<injection>
{injection}
</injection>

Test cases that fail because of it: {failing}

## Task
Write a standalone reproducer: a single file `repro.js` in the current directory, run as
`<node binary> repro.js` from an empty directory, using only Node.js built-in modules.
(If the bug can only be shown from the shell, e.g. command-line flags, write `repro.sh`
instead, run as `bash repro.sh <node binary>`; it must use "$1" as the node binary.)
Requirements:
- With the clean binary, its output (stdout+stderr) and exit status must be deterministic
  (identical on every run: no timestamps, random values, PIDs, timing-dependent output, absolute
  paths of temporary files).
- With the buggy binary (./out/Release/node), its output or exit status must differ, because of the
  bug itself. Do not print process.version, process.execPath, file paths or anything that differs
  between the two builds for reasons other than the bug.
- It must finish within 30 seconds on both, and create files only under os.tmpdir() or the current directory.
Check it yourself, e.g.:
  mkdir -p {scratch}/r && cd {scratch}/r && {clean} $OLDPWD/repro.js; echo "exit=$?"
  cd {scratch}/r && $OLDPWD/out/Release/node $OLDPWD/repro.js; echo "exit=$?"
Do not modify anything under lib/, src/ or test/. Write only repro.js (or repro.sh) and,
optionally, REPRO_NOTES.md with a short explanation. No network access; local ports work.
"""


def normalise(text, node, rundir):
    text = text.replace(node, "<NODE>").replace(rundir, "<RUNDIR>")
    text = re.sub(re.escape(W) + r"/[^\s'\"):]*", "<PATH>", text)
    text = re.sub(r"/tmp/[^\s'\"):]*", "<TMP>", text)
    text = re.sub(r"\(node:\d+\)", "(node:<PID>)", text)
    return text


def run_repro(script, node, scratch):
    import memwatch
    memwatch.require()
    rundir = tempfile.mkdtemp(prefix="repro-", dir=scratch)
    try:
        shutil.copy(script, os.path.join(rundir, os.path.basename(script)))
        name = os.path.basename(script)
        cmd = [node, name] if name.endswith(".js") else ["bash", name, node]
        env = {"PATH": "/usr/bin:/bin", "HOME": rundir, "TMPDIR": rundir, "LANG": "C.UTF-8"}
        try:
            p = subprocess.run(cmd, cwd=rundir, env=env, capture_output=True, timeout=RUN_TIMEOUT)
            out = (p.stdout + b"\n--stderr--\n" + p.stderr).decode(errors="replace")
            rc = p.returncode
        except subprocess.TimeoutExpired:
            out, rc = "<TIMEOUT>", "timeout"
        return normalise(out, node, rundir), rc
    finally:
        shutil.rmtree(rundir, ignore_errors=True)


def verify(script, inj, gslot, scratch, cctest=False):
    """Harness verification. Returns dict with verdict and outputs."""
    if re.search(r"(?<![\w.])/(?:home|root|tmp|opt|usr/local)/", open(script, errors="replace").read()):
        return {"verdict": "not-standalone (absolute local path)"}
    clean = [run_repro(script, CLEAN_NODE, scratch) for _ in range(3)]
    res = {"clean_deterministic": len(set(map(str, clean))) == 1,
           "clean_output": clean[0][0][-4000:], "clean_exit": clean[0][1]}
    if not res["clean_deterministic"]:
        res["verdict"] = "clean-nondeterministic"
        return res
    S.require_pristine(gslot)
    files = S.patch_files(inj.decode(errors="replace"))
    if S.apply(gslot, inj, fuzz=False) is None:
        S.restore(gslot, files)
        res["verdict"] = "inject-apply-fail"
        return res
    try:
        if not S.build(gslot):
            res["verdict"] = "inject-build-fail"
            return res
        injd = [run_repro(script, os.path.join(gslot, "out/Release/node"), scratch) for _ in range(2)]
    finally:
        subprocess.run(["patch", "-p1", "-R", "-s", "--no-backup-if-mismatch"], cwd=gslot, input=inj)
        bad = S.matches_pristine(gslot, files)
        if bad:
            S.restore(gslot, files)
            res["revert_bad"] = bad
    res["inj_output"] = injd[0][0][-4000:]
    res["inj_exit"] = injd[0][1]
    differs = all(o != clean[0] for o in injd)
    if not differs:
        res["verdict"] = "no-difference"
    elif re.search(r"v\d+\.\d+\.\d+", clean[0][0] + injd[0][0]) and \
            re.sub(r"v\d+\.\d+\.\d+", "<V>", clean[0][0]) == re.sub(r"v\d+\.\d+\.\d+", "<V>", injd[0][0]) \
            and clean[0][1] == injd[0][1]:
        res["verdict"] = "differs-only-by-version"
    else:
        res["verdict"] = "verified"
    return res


def repro_one(bug, aslot, gslot, args):
    sha = bug["sha"]
    out = {"sha": sha, "tier": bug["tier"]}
    inj = bug["injection"].encode()
    logdir = os.path.join(args.logroot, sha[:12])
    scratch = os.path.join(agents.SCRATCH, "repro-" + sha[:12])
    os.makedirs(scratch, exist_ok=True)
    agents.restore_slot(aslot)
    for f in ("repro.js", "repro.sh", "REPRO_NOTES.md"):
        if os.path.exists(os.path.join(aslot, f)):
            os.remove(os.path.join(aslot, f))
    files = S.patch_files(bug["injection"])
    assert S.apply(aslot, inj, fuzz=False), "injection does not apply in agent slot"
    try:
        if not S.build(aslot):
            out["status"] = "inject-build-fail"
            return out
        prompt = PROMPT.format(clean=CLEAN_NODE, sha=sha, subject=bug["subject"],
                               message=bug.get("body", "")[:4000], injection=bug["injection"][:30000],
                               failing=", ".join(bug["failing"]), scratch=scratch)
        ar = agents.run_agent(aslot, prompt, args.model, args.agent_budget, args.max_turns,
                              args.wall, args.ledger, "repro", logdir)
        out["agent"] = {k: v for k, v in ar.items() if k != "result"}
        if ar.get("retryable"):
            out["status"] = "retryable-error"
            return out
        script = None
        for f in ("repro.js", "repro.sh"):
            if os.path.exists(os.path.join(aslot, f)):
                script = os.path.join(logdir, f)
                shutil.copy(os.path.join(aslot, f), script)
                break
        if os.path.exists(os.path.join(aslot, "REPRO_NOTES.md")):
            shutil.copy(os.path.join(aslot, "REPRO_NOTES.md"), os.path.join(logdir, "REPRO_NOTES.md"))
    finally:
        for f in ("repro.js", "repro.sh", "REPRO_NOTES.md"):
            if os.path.exists(os.path.join(aslot, f)):
                os.remove(os.path.join(aslot, f))
        agents.restore_slot(aslot)
    if not script:
        out["status"] = "no-script"
        shutil.rmtree(scratch, ignore_errors=True)
        return out
    out["script"] = os.path.basename(script)
    out["script_text"] = open(script, errors="replace").read()
    with args.gslot_lock[gslot]:
        with gate.BUILD_LOCK:
            v = verify(script, inj, gslot, scratch)
    shutil.rmtree(scratch, ignore_errors=True)
    out["verify"] = v
    out["status"] = v["verdict"]
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--bugs", required=True, help="jsonl of gated bugs (sha, tier, injection, failing, subject, body)")
    ap.add_argument("--out", required=True)
    ap.add_argument("--ledger", required=True)
    ap.add_argument("--cap-usd", type=float, required=True)
    ap.add_argument("--agent-slots", required=True)
    ap.add_argument("--gate-slots", required=True)
    ap.add_argument("--model", default=agents.AGENT_MODEL)
    ap.add_argument("--agent-budget", type=float, default=1.5)
    ap.add_argument("--max-turns", type=int, default=60)
    ap.add_argument("--wall", type=int, default=1800)
    ap.add_argument("--limit", type=int)
    ap.add_argument("--logroot", default=os.path.expanduser("~/node-etna-work/agentlogs/repro"))
    a = ap.parse_args()
    done = set()
    if os.path.exists(a.out):
        done = {json.loads(l)["sha"] for l in open(a.out) if json.loads(l)["status"] != "retryable-error"}
    bugs = [json.loads(l) for l in open(a.bugs)]
    bugs = [b for b in bugs if b["sha"] not in done]
    # Bugs with a fix-added failing case first (strict candidates), newest first.
    bugs.sort(key=lambda b: (not b.get("added_failing"), [-ord(ch) for ch in b["date"]]))
    if a.limit:
        bugs = bugs[:a.limit]
    q = queue.Queue()
    for b in bugs:
        q.put(b)
    gslots = a.gate_slots.split(",")
    a.gslot_lock = {g: threading.Lock() for g in gslots}
    lock = threading.Lock()

    def worker(i, aslot):
        gslot = gslots[i % len(gslots)]
        while True:
            if llm.spent(a.ledger, "repro") >= a.cap_usd:
                print("repro spend cap reached", flush=True)
                return
            if os.path.exists(gate.STOP_FILE):
                print("STOP file present; stopping cleanly", flush=True)
                return
            try:
                b = q.get_nowait()
            except queue.Empty:
                return
            try:
                r = repro_one(b, aslot, gslot, a)
            except Exception:
                r = {"sha": b["sha"], "status": "error", "error": traceback.format_exc()[-3000:]}
                agents.restore_slot(aslot)
            with lock:
                with open(a.out, "a") as f:
                    f.write(json.dumps(r) + "\n")
                print(f"{b['sha'][:10]} {r['status']:24} ${r.get('agent', {}).get('cost_usd', 0):.2f} "
                      f"{b['subject'][:60]}", flush=True)

    ts = [threading.Thread(target=worker, args=(i, s)) for i, s in enumerate(a.agent_slots.split(","))]
    for t in ts:
        t.start()
    for t in ts:
        t.join()
    print(f"repro spend so far: ${llm.spent(a.ledger, 'repro'):.2f}", flush=True)


if __name__ == "__main__":
    main()
