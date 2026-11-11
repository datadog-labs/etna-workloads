"""Launch a headless Claude Code agent in a bwrap sandbox.

The agent may write only its work dir and the given extra dirs (e.g. its own
build slot); no outbound network (localhost works inside a command); no
CLAUDE.md / AGENTS.md loading (the rustc tree ships agent instructions meant
for upstream contributors).
"""
import json
import os
import subprocess
import time

import llm
import memguard
import runner

MODEL = "claude-sonnet-5-5"


def settings(workdir, writable, readable):
    allow_edit = [f"Edit(/{p}/**)" for p in [workdir, *writable]]
    allow_read = [f"Read(/{p}/**)" for p in [workdir, *writable, *readable]]
    return {
        "permissions": {
            "defaultMode": "dontAsk",
            # Only writable dirs become working directories: listing read-only dirs here
            # let the Write tool write into them and made the sandbox create placeholder
            # files (.mcp.json) in them.
            "additionalDirectories": list(writable),
            "allow": allow_edit + allow_read + ["Bash", "Glob", "Grep"],
            "deny": ["WebFetch", "WebSearch", "Bash(git push*)", "Bash(git commit*)", "Bash(sudo*)"]
                    + [f"Edit(/{p}/**)" for p in readable],
            "blockWritesOutsideWorkingDirectories": True,
        },
        "sandbox": {
            "enabled": True,
            "autoAllowBashIfSandboxed": True,
            "failIfUnavailable": True,
            "allowUnsandboxedCommands": False,
            "filesystem": {"allowWrite": [workdir, *writable]},
            "network": {"allowedDomains": [], "deniedDomains": [], "strictAllowlist": True},
        },
        "env": {"CLAUDE_CODE_DISABLE_CLAUDE_MDS": "1"},
        "pluginConfigs": {"cc-plugin-agents-md@builtin": {"options": {"instructionFiles": "managed-only"}}},
    }


def launch(prompt, workdir, stage, key, writable=(), readable=(), model=MODEL,
           max_budget=None, timeout=5400, effort=None):
    """Run the agent; returns dict(result, cost, is_error, turns, transcript path)."""
    os.makedirs(workdir, exist_ok=True)
    sp = os.path.join(workdir, ".agent-settings.json")
    json.dump(settings(workdir, list(writable), list(readable)), open(sp, "w"), indent=1)
    cmd = ["claude", "-p", "--model", model, "--output-format", "json",
           "--settings", sp, "--setting-sources", "user", "--permission-mode", "dontAsk",
           "--strict-mcp-config", "--disallowedTools", "mcp__*,WebFetch,WebSearch"]
    if max_budget:
        cmd += ["--max-budget-usd", str(max_budget)]
    if effort:
        cmd += ["--effort", effort]
    env = dict(os.environ, CLAUDE_CODE_DISABLE_CLAUDE_MDS="1")
    llm.wait_for_credentials()
    runner.wait_for_disk()  # agents build too; never start one on a full disk
    t = time.time()
    try:
        with memguard.permit("agent"):
            r = subprocess.run(cmd, input=prompt, capture_output=True, text=True, cwd=workdir,
                               timeout=timeout, env=env)
        out = r.stdout
    except subprocess.TimeoutExpired as e:
        out = e.stdout.decode() if isinstance(e.stdout, bytes) else (e.stdout or "")
    try:
        d = json.loads(out)
    except Exception:  # noqa: BLE001
        d = {"is_error": True, "result": f"unparseable output: {out[-2000:]}", "api_error": True}
    cost = d.get("total_cost_usd") or 0.0
    llm.record(stage, key, cost, dict(model=model, secs=round(time.time() - t)))
    res = dict(result=d.get("result"), cost=cost, is_error=d.get("is_error", True),
               turns=d.get("num_turns"), session_id=d.get("session_id"),
               subtype=d.get("subtype"), secs=round(time.time() - t))
    # API-side failures are retryable, never results.
    txt = str(d.get("result") or "")
    res["api_error"] = bool(d.get("api_error")) or (res["is_error"] and any(
        s in txt for s in ("API Error", "overloaded", "rate limit", "Credit", "authentication", "529", "500")))
    return res
