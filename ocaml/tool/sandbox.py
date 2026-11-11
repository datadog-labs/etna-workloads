"""Sandboxed headless agent launcher + a self-check of the sandbox.

Agents may write only their work directory (and its tmp/); no outbound network;
local sockets/ports allowed.  Verified from outside by sbx_check()."""
import json, os, shutil, subprocess, sys, time
from pathlib import Path
from common import *
import llm


def agent_settings(workdir):
    w = str(workdir)
    st = {
        "sandbox": {
            "enabled": True,
            "autoAllowBashIfSandboxed": True,
            "allowUnsandboxedCommands": False,
            "network": {"allowedDomains": [], "allowLocalBinding": True,
                        "allowAllUnixSockets": True},
            "filesystem": {"allowWrite": [w]},
        },
        "permissions": {
            "defaultMode": "dontAsk",
            "allow": ["Bash", "Read", "Glob", "Grep", f"Edit({w}/**)", f"Write({w}/**)"],
            # the agent must not touch this repository (tooling, exported dataset)
            "deny": ["WebFetch", "WebSearch", f"Edit(/{ROOT}/**)", f"Write(/{ROOT}/**)"],
        },
    }
    if llm.HELPER:
        st["apiKeyHelper"] = llm.HELPER
    return st


def run_agent(prompt, workdir, stage, key, model="sonnet", timeout=5400, budget=None):
    workdir = Path(workdir)
    (workdir / "tmp").mkdir(parents=True, exist_ok=True)
    sf = workdir / ".agent-settings.json"
    sf.write_text(json.dumps(agent_settings(workdir)))
    llm.wait_api()
    args = ["claude", "-p", "--bare", "--settings", str(sf), "--model", model,
            "--output-format", "json", "--no-session-persistence",
            "--tools", "Bash,Read,Edit,Write,Glob,Grep"]
    if budget:
        args += ["--max-budget-usd", str(budget)]
    env = dict(os.environ, TMPDIR=str(workdir / "tmp"))
    for k in ("CLAUDECODE", "CLAUDE_CODE_SESSION_ID", "CLAUDE_CODE_CHILD_SESSION", "CLAUDE_PID",
              "CLAUDE_CODE_MESSAGING_SOCKET", "CLAUDE_CODE_MESSAGING_TOKEN"):
        env.pop(k, None)
    t = time.time()
    try:
        from slots import limit_mem
        r = subprocess.run(args, input=prompt, capture_output=True, text=True, cwd=workdir,
                           timeout=timeout, env=env, preexec_fn=limit_mem(16 << 30))
    except subprocess.TimeoutExpired:
        return None, dict(retryable=True, error="timeout", secs=round(time.time() - t))
    try:
        d = json.loads(r.stdout)
    except Exception:
        return None, dict(retryable=True, error="bad-json", stderr=r.stderr[-2000:], stdout=r.stdout[-2000:])
    cost = d.get("total_cost_usd") or 0.0
    llm.record(stage, key, cost, dict(model=model, turns=d.get("num_turns")))
    info = dict(cost=cost, turns=d.get("num_turns"), subtype=d.get("subtype"), secs=round(time.time() - t))
    if d.get("is_error") and d.get("subtype") not in ("error_max_budget_usd", "error_max_turns"):
        info.update(retryable=True, error=str(d.get("result"))[:500])
        return None, info
    return d.get("result"), info


def sbx_check():
    wd = WORK / "sbx-check"
    shutil.rmtree(wd, ignore_errors=True)
    wd.mkdir(parents=True)
    outside = WORK / "sbx-outside-probe"
    outside.unlink(missing_ok=True)
    prompt = f"""Run these shell commands one at a time with the Bash tool and report each exit status. Do not try workarounds.
1. echo inside > {wd}/inside.txt
2. echo outside > {outside}
3. curl -sS -m 10 https://example.com -o {wd}/net.html
4. python3 -c "import socket;s=socket.socket();s.bind(('127.0.0.1',0));s.listen();c=socket.create_connection(s.getsockname());a,_=s.accept();c.send(b'ok');open('{wd}/sock.txt','w').write(a.recv(2).decode())"
5. echo x > $TMPDIR/t && echo tmpok > {wd}/tmp.txt
"""
    out, info = run_agent(prompt, wd, "sbx-check", "sbx", model="haiku", timeout=600)
    res = dict(
        write_inside=(wd / "inside.txt").exists(),
        write_outside_blocked=not outside.exists(),
        network_blocked=not (wd / "net.html").exists() or (wd / "net.html").stat().st_size == 0,
        local_socket=(wd / "sock.txt").exists() and (wd / "sock.txt").read_text() == "ok",
        tmpdir=(wd / "tmp.txt").exists(),
        info=info)
    res["ok"] = all(res[k] for k in ("write_inside", "write_outside_blocked", "network_blocked", "local_socket", "tmpdir"))
    return res, out


if __name__ == "__main__":
    r, out = sbx_check()
    print(json.dumps(r, indent=1)); print(out)
