#!/usr/bin/env python3
"""Adapted tier: an agent re-expresses a fix's bug in today's code; the harness re-verifies it.

Slot layout (agent cwd = SLOT, the only writable place in its sandbox):
  SLOT/src     configured build tree of the release (agent edits src/src, src/include ... only)
  SLOT/bin     etna-check (build + run oracle once) and oracle.json
  SLOT/notes   RATIONALE.md written by the agent; build logs
After the agent: changes outside src/src (the SCOPE) reject the attempt; otherwise the injection is the
src/ diff against the pristine release, and the harness gates it from a freshly synced tree
(build, oracle twice, reversal byte-for-byte) and tries a mechanical reproducer.
usage: adapt.py SLOT --sha SHA [--model sonnet] [--budget 5]
"""
import argparse, json, os, shutil, subprocess, sys, time
import common, gate, llm, repro, runtests
from common import sh

PROMPT = """You are working on DuckDB {release} (C++), checked out and already built in ./src.
Your job: re-introduce, into today's code, the bug that the upstream commit below fixed, so that the
fix's own tests fail again. This is for a dataset of realistic bugs used to evaluate testing tools.

## The upstream fix
commit {sha} ({date})
{subject}

{body}

PR: {pr}

Its implementation diff applied to its parent (reverse-applying it to {release} {why}):
```diff
{impl_diff}
```

Its test changes (for reference; do NOT modify tests):
```diff
{test_diff}
```

## Oracle
These test units (they pass on the clean {release} build) should fail with your change:
{units}

Run `./bin/etna-check` to build incrementally and run them. A build takes about 5-15 minutes, and a header
change can take 40+ minutes on this busy machine: run it as a background task and wait for its
completion notice (do not poll in a loop), and avoid unnecessary rebuilds. It exits 0 when at least one oracle unit fails.

## Rules
- Edit only implementation files under ./src/src/ (C++ sources and headers of the engine). Never edit
  tests, test data, build files, scripts, third_party/ or extension/.
- Every hunk you change must correspond to a hunk of the fix above: undo what the fix did, expressed
  in today's code. Keep the change minimal. Do not invent a different bug, and do not make a test fail
  in some other way (e.g. by throwing an unrelated error or crashing on purpose).
- Keep the build green.
- When done, write ./notes/RATIONALE.md: for each hunk you changed, the file/function, which hunk of
  the fix it traces to, and why it brings back the original behaviour; then which oracle units fail
  and how (paste the relevant etna-check lines).
- If the buggy code no longer exists in a form that can be re-introduced faithfully, leave ./src
  unchanged and write ./notes/RATIONALE.md starting with "NOT POSSIBLE:" and the reason.
- Do not use git; there is no network.
"""

SETTINGS = {
    "sandbox": {"enabled": True, "autoAllowBashIfSandboxed": True, "allowUnsandboxedCommands": False,
                "network": {"allowLocalBinding": True, "allowedDomains": []}},
    "permissions": {"allow": ["Bash", "Read", "Edit", "Write", "Glob", "Grep"], "deny": ["WebFetch", "WebSearch"],
                    "defaultMode": "acceptEdits"},
}


def test_diff(c):
    d = sh(["git", "-C", common.UPSTREAM, "diff", "--no-renames", c["parent"], c["sha"], "--", "test/"]).stdout
    d = d.decode("utf-8", "replace")
    return d if len(d) < 15000 else d[:15000] + "\n... [truncated]"


def outside_scope_changes(slot_src):
    """Files differing from pristine outside src/ (excluding build outputs); symlinked paths ignored."""
    r = sh(["rsync", "-rlcn", "--delete", "--out-format=%n", "--exclude=/build/", "--exclude=/duckdb_unittest_tempdir/",
            "--exclude=/src/", common.PRISTINE + "/", slot_src + "/"])
    names = [l for l in r.stdout.decode().splitlines() if l and not l.endswith("/")]
    # bytecode caches from running the project's own generator scripts are by-products, not edits
    names = [n for n in names if "__pycache__/" not in n and not n.endswith(".pyc")]
    return [n for n in names if not os.path.islink(os.path.join(slot_src, n))]


def run_agent(slot, c, oracle, why, model, budget, timeout):
    for d in ("bin", "notes", "runtmp", "tmp"):
        shutil.rmtree(os.path.join(slot, d), ignore_errors=True); os.makedirs(os.path.join(slot, d))
    shutil.copy(os.path.join(common.TOOL, "etna_check.py"), os.path.join(slot, "bin", "etna-check"))
    common.write_json(os.path.join(slot, "bin", "oracle.json"),
                      {"tool": common.TOOL, "version": common.RELEASE, "units": oracle})
    json.dump(SETTINGS, open(os.path.join(slot, "notes", ".settings.json"), "w"))
    impl = common.impl_diff(c["sha"], c["parent"]).decode("utf-8", "replace")
    if len(impl) > 30000:
        impl = impl[:30000] + "\n... [truncated]"
    prompt = PROMPT.format(release=common.RELEASE, sha=c["sha"], date=time.strftime("%Y-%m-%d", time.gmtime(c["time"])),
                           subject=c["subject"], body=c["body"][:3000], pr=c.get("pr_title") or "", why=why,
                           impl_diff=impl, test_diff=test_diff(c), units="\n".join("- " + u for u in oracle))
    cmd = ["python3", os.path.join(common.TOOL, "guard.py"), "--timeout", str(timeout), "--rss-mb", "56000",
           "--log", os.path.join(slot, "notes", "agent.json"), "--cwd", slot, "--",
           "claude", "-p", "--model", model, "--settings", os.path.join(slot, "notes", ".settings.json"),
           "--setting-sources", "", "--strict-mcp-config", "--no-session-persistence",
           "--output-format", "json", "--max-budget-usd", str(budget), prompt]
    t0 = time.time()
    p = sh(cmd)
    out = open(os.path.join(slot, "notes", "agent.json"), errors="replace").read()
    d = llm.parse_claude_json(out)
    cost = d.get("total_cost_usd") or 0.0
    g = [l for l in p.stderr.decode().splitlines() if l.startswith("GUARD ")]
    return {"cost": cost, "is_error": d.get("is_error"), "result": (d.get("result") or "")[-3000:],
            "num_turns": d.get("num_turns"), "secs": round(time.time() - t0), "guard": json.loads(g[-1][6:]) if g else None,
            "model": list(d.get("modelUsage", {}).keys()), "raw_error": None if d else out[-1500:]}


def adapt(slot, c, oracle, why, model, budget, timeout, outdir):
    src = os.path.join(slot, "src")
    common.sync_tree(src)
    res = {"sha": c["sha"], "subject": c["subject"], "tier": "adapted", "model": model, "oracle": oracle}
    ag = run_agent(slot, c, oracle, why, model, budget, timeout)
    timed_out = (ag.get("guard") or {}).get("status") == "timeout"
    if not ag["model"] and not ag["cost"] and timed_out:
        # killed agents print no usage; book the per-attempt cap as an upper bound so caps stay honest
        ag["cost"] = budget; ag["cost_estimated"] = True
    llm.record({"stage": "adapted", "cost": ag["cost"], "ok": not ag["is_error"], "sha": c["sha"], "model": model,
                "estimated": bool(ag.get("cost_estimated"))})
    res["agent"] = ag
    for f in ("RATIONALE.md", "last-build.log"):
        p = os.path.join(slot, "notes", f)
        if os.path.exists(p):
            shutil.copy(p, os.path.join(outdir, f))
    shutil.copy(os.path.join(slot, "notes", "agent.json"), os.path.join(outdir, "agent.json"))
    rat = open(os.path.join(outdir, "RATIONALE.md"), errors="replace").read() if os.path.exists(os.path.join(outdir, "RATIONALE.md")) else ""
    # save whatever the agent changed before any verdict
    bad = outside_scope_changes(src)
    inj = common.tree_diff(common.PRISTINE, src)
    open(os.path.join(outdir, "injection.patch"), "wb").write(inj)
    if ag["is_error"] and llm.is_api_error(ag["result"]):
        res["verdict"] = "infra"; res["why"] = "API/credential error during the agent run: " + ag["result"][-200:]
        common.sync_tree(src); return res
    if timed_out:
        res["verdict"] = "agent-timeout"   # a result (no retry as infra); its partial diff is kept for inspection
        common.sync_tree(src); return res
    if not ag["model"] and not ag["cost"]:
        res["verdict"] = "infra"; res["why"] = "agent did not run (API/credential?)"
        common.sync_tree(src); return res
    res["outside_scope"] = bad
    if bad:
        res["verdict"] = "rejected-outside-scope"
    elif not inj.strip():
        res["verdict"] = "not-possible" if rat.strip().startswith("NOT POSSIBLE") else "no-change"
    elif not rat.strip():
        res["verdict"] = "no-rationale"
    if "verdict" in res:
        common.sync_tree(src); return res
    # harness re-verification from a freshly synced tree
    common.sync_tree(src)
    if gate.apply_patch(src, inj) != "clean":
        res["verdict"] = "apply-fail"; return res

    def make_repro(tree, r):
        details = {u: r["runs"][0][u][1] for u in r["failing"]}
        rep, attempts = repro.mechanical(common.BASE, tree, r["failing"], details)
        if rep:
            open(os.path.join(outdir, "repro.sql"), "w").write(rep["sql"])
        return {"repro": rep, "repro_attempts": attempts}
    res.update(gate.gate(src, inj, oracle, outdir, jobs=6, on_injected=make_repro))
    common.sync_tree(src)
    return res


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("slot"); ap.add_argument("--sha", required=True); ap.add_argument("--model", default="sonnet")
    ap.add_argument("--budget", type=float, default=5); ap.add_argument("--timeout", type=int, default=5400)
    ap.add_argument("--why", default="does not apply")
    a = ap.parse_args()
    c = [x for x in common.candidates() if x["sha"].startswith(a.sha)][0]
    base = common.base_oracle()
    oracle = [u for u in common.units_map()[c["sha"]]["units"] if base.get(u) == "pass"]
    outdir = os.path.join(common.RESULTS, "adapted", c["sha"]); os.makedirs(outdir, exist_ok=True)
    while not llm.credential_ok():
        print("credential probe failed; waiting", flush=True); time.sleep(120)
    r = adapt(os.path.abspath(a.slot), c, oracle, a.why, a.model, a.budget, a.timeout, outdir)
    common.write_json(os.path.join(outdir, "result.json"), r)
    print(r["verdict"], r.get("failing"), "cost", r["agent"]["cost"] if "agent" in r else None)
