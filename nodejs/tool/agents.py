"""Shared machinery for headless, sandboxed Claude Code agents working in agent slots."""
import json, os, subprocess, time
import llm, slot as S

W = S.W
SETTINGS = os.path.join(W, "agent-cfg/sandbox.settings.json")
SCRATCH = os.path.join(W, "scratch")
AGENT_MODEL = "claude-sonnet-5-5"   # mid-size default
RETRY_MODEL = "claude-opus-5-5"     # largest, for retries only
# Directories restored from pristine after every agent (lib/src with --delete so
# agent-created files vanish; the others restore modified files only).
RESTORE_DELETE = ["lib", "src"]
RESTORE_KEEP = ["test", "tools", "deps", "doc", "benchmark"]
RSYNC_EXCLUDES = ["build/", ".tmp.*", "__pycache__/", "*.pyc", ".buildstamp", ".headersbuildstamp",
                  ".docbuildstamp", "node_trace.*"]


def wait_for_credentials(max_wait=6 * 3600):
    """Block until the API credential helper works (never launch while it fails)."""
    t0 = time.time()
    delay = 60
    while True:
        try:
            llm.token()
            return True
        except llm.RetryableError:
            if time.time() - t0 > max_wait:
                return False
            print(f"credential helper failing; waiting {delay}s", flush=True)
            time.sleep(delay)
            delay = min(delay * 2, 900)


def agent_env():
    env = dict(os.environ)
    for k in ("CLAUDECODE", "CLAUDE_CODE_SESSION_ID", "CLAUDE_CODE_CHILD_SESSION",
              "CLAUDE_CODE_MESSAGING_SOCKET", "CLAUDE_CODE_MESSAGING_TOKEN",
              "CLAUDE_CODE_ENTRYPOINT", "CLAUDE_PID", "NODE_OPTIONS"):
        env.pop(k, None)
    env.update(S.CCACHE_ENV)
    return env


def run_agent(cwd, prompt, model, budget_usd, max_turns, wall_s, ledger, stage, logdir):
    """Run one headless agent. Returns dict with cost, subtype, result text, retryable flag."""
    import memwatch
    memwatch.require()  # agents run tests with slot binaries; the watchdog caps their RSS
    if not wait_for_credentials():
        return {"retryable": True, "error": "credential helper unavailable"}
    os.makedirs(logdir, exist_ok=True)
    open(os.path.join(logdir, "prompt.txt"), "w").write(prompt)
    cmd = ["claude", "-p", prompt, "--model", model, "--settings", SETTINGS,
           "--permission-mode", "dontAsk", "--output-format", "json",
           "--max-turns", str(max_turns), "--max-budget-usd", str(budget_usd)]
    t0 = time.time()
    try:
        p = subprocess.run(cmd, cwd=cwd, env=agent_env(), stdin=subprocess.DEVNULL,
                           capture_output=True, text=True, timeout=wall_s)
        out, err, rc = p.stdout, p.stderr, p.returncode
    except subprocess.TimeoutExpired as e:
        out = e.stdout.decode(errors="replace") if isinstance(e.stdout, bytes) else (e.stdout or "")
        err, rc = "wall-clock timeout", -1
    open(os.path.join(logdir, "stdout.json"), "w").write(out or "")
    open(os.path.join(logdir, "stderr.txt"), "w").write(err or "")
    res = {"secs": round(time.time() - t0), "rc": rc, "model": model}
    try:
        d = json.loads(out)
    except (json.JSONDecodeError, TypeError):
        d = {}
    res["cost_usd"] = d.get("total_cost_usd", 0.0) or 0.0
    res["subtype"] = d.get("subtype")
    res["is_error"] = d.get("is_error")
    res["num_turns"] = d.get("num_turns")
    res["result"] = (d.get("result") or "")[-4000:]
    # API/infra errors are retryable, never results.
    text = (res["result"] + (err or "")).lower()
    res["retryable"] = (not d) or (d.get("is_error") and any(
        s in text for s in ("api error", "overloaded", "rate limit", "529", "credential",
                            "authentication", "connection error", "timed out")))
    with open(ledger, "a") as f:
        f.write(json.dumps({"t": time.time(), "stage": stage, "model": model,
                            "usd": res["cost_usd"], "agent": True, "cwd": cwd}) + "\n")
    return res


def changed_impl_files(slotdir):
    """Implementation files (lib/, src/) that differ from pristine; symlinks are ignored."""
    out = []
    for top in ("lib", "src"):
        r = subprocess.run(["diff", "-rq", "--no-dereference", os.path.join(S.PRISTINE, top),
                            os.path.join(slotdir, top)], capture_output=True, text=True)
        for line in r.stdout.splitlines():
            if line.startswith("Files "):
                a = line.split(" and ")[0][len("Files "):]
                rel = os.path.relpath(a, S.PRISTINE)
            elif line.startswith("Only in "):
                d, name = line[len("Only in "):].split(": ", 1)
                base = S.PRISTINE if d.startswith(S.PRISTINE) else slotdir
                rel = os.path.relpath(os.path.join(d, name), base)
            else:
                continue  # symlink notes etc.
            p = os.path.join(slotdir, rel)
            if os.path.islink(p) or any(os.path.islink(os.path.join(slotdir, *rel.split("/")[:i]))
                                        for i in range(1, rel.count("/") + 1)):
                continue
            if os.path.isdir(p) or os.path.isdir(os.path.join(S.PRISTINE, rel)):
                # whole new/removed directory: list its files
                root = p if os.path.isdir(p) else os.path.join(S.PRISTINE, rel)
                for dp, _, fs in os.walk(root):
                    for fn in fs:
                        out.append(os.path.relpath(os.path.join(dp, fn),
                                                   slotdir if root == p else S.PRISTINE))
            else:
                out.append(rel)
    return sorted(set(out))


def other_changes(slotdir):
    """Non-implementation source files the agent changed (tests etc.); recorded, never used."""
    out = []
    for top in RESTORE_KEEP:
        r = subprocess.run(["rsync", "-rlcn", "--itemize-changes", "--chmod=u+w",
                            *[f"--exclude={e}" for e in RSYNC_EXCLUDES],
                            os.path.join(S.PRISTINE, top) + "/", os.path.join(slotdir, top) + "/"],
                           capture_output=True, text=True)
        out += [f"{top}/{l.split(' ', 1)[1]}" for l in r.stdout.splitlines()
                if l.startswith((">f", "cL"))]
    return out


def restore_slot(slotdir):
    """Bring the agent slot's sources back to pristine; verify lib/src."""
    import nodetest
    nodetest.reap(slotdir)  # processes an agent's tests left behind
    for top in RESTORE_DELETE:
        subprocess.run(["rsync", "-rlc", "--delete", "--chmod=u+w",
                        os.path.join(S.PRISTINE, top) + "/", os.path.join(slotdir, top) + "/"],
                       check=True)
    for top in RESTORE_KEEP:
        subprocess.run(["rsync", "-rlc", "--chmod=u+w", *[f"--exclude={e}" for e in RSYNC_EXCLUDES],
                        os.path.join(S.PRISTINE, top) + "/", os.path.join(slotdir, top) + "/"],
                       check=True)
    drift = S.scope_drift(slotdir)
    if drift:
        raise RuntimeError(f"slot {slotdir} not pristine after restore:\n{drift[:2000]}")
