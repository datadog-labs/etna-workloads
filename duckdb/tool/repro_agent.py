#!/usr/bin/env python3
"""Reproducer agent: for a gated bug without a mechanical reproducer, an agent writes a standalone SQL
script; the harness (never the agent's word) accepts it with repro.verify().

The slot holds the injected build (agent cwd = SLOT; ./src is the injected tree, read it but do not edit).
usage: repro_agent.py SLOT --result results/<tier>/<sha>/result.json [--model sonnet] [--budget 2]
"""
import argparse, json, os, shutil, sys, time
import common, gate, llm, repro
from common import sh
from adapt import SETTINGS

PROMPT = """A bug has been injected into DuckDB {release} (C++). Your job: write a standalone SQL script
that exposes it, for a dataset used to evaluate testing tools.

The injected build is in ./src (shell: ./src/build/relassert/duckdb). A clean build of the same release
is at {clean}/build/relassert/duckdb (read-only). Both run from their tree root, so relative paths such as
data/csv/... resolve to the release's test data.

## The injected change (a reversal of upstream fix {sha}: "{subject}")
```diff
{injection}
```

## The failing tests on the injected build
{failing}

## What to deliver
Write ./notes/repro.sql: plain SQL (DuckDB shell dot-commands allowed) that, run as
`duckdb -batch -init /dev/null -f repro.sql :memory:` from the tree root, prints different output or exits
differently on the injected build than on the clean build, with deterministic output on the clean build.
Check it with `./bin/repro-check ./notes/repro.sql` (it runs exactly the harness's acceptance check).
Rules: the script must be standalone: no absolute paths, and do not write files (no COPY TO, EXPORT,
ATTACH of a file, or similar); reading the release's relative data/ files is fine; do not print versions,
platform or source identifiers; do not depend on timing, randomness or
thread scheduling; keep it short (prefer the smallest script that shows the bug); do not modify ./src.
If you cannot find one, write ./notes/repro.sql containing only "-- NOT FOUND: <reason>".
"""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("slot"); ap.add_argument("--result", required=True)
    ap.add_argument("--model", default="sonnet"); ap.add_argument("--budget", type=float, default=2.0)
    ap.add_argument("--timeout", type=int, default=2700)
    a = ap.parse_args()
    return run(os.path.abspath(a.slot), a.result, a.model, a.budget, a.timeout)


def run(slot, result_path, model, budget, timeout):
    class A: pass
    a = A(); a.result, a.model, a.budget, a.timeout = result_path, model, budget, timeout
    src = os.path.join(slot, "src")
    rdir = os.path.dirname(os.path.abspath(a.result))
    r = json.load(open(a.result))
    c = [x for x in common.candidates() if x["sha"] == r["sha"]][0]
    inj = open(os.path.join(rdir, "injection.patch"), "rb").read()
    common.sync_tree(src)
    assert gate.apply_patch(src, inj) == "clean"
    b = gate.build(src, os.path.join(rdir, "repro-agent-build.log"))
    out = {"sha": c["sha"], "model": a.model}
    if b["status"] != "exit" or b["rc"] != 0:
        out["verdict"] = "infra" if b.get("infra") else "build-fail"
        common.sync_tree(src); return out, rdir
    for d in ("bin", "notes", "runtmp", "tmp"):
        shutil.rmtree(os.path.join(slot, d), ignore_errors=True); os.makedirs(os.path.join(slot, d))
    shutil.copy(os.path.join(common.TOOL, "repro_check.py"), os.path.join(slot, "bin", "repro-check"))
    common.write_json(os.path.join(slot, "bin", "repro.json"), {"tool": common.TOOL, "work": common.WORK, "clean": common.BASE})
    json.dump(SETTINGS, open(os.path.join(slot, "notes", ".settings.json"), "w"))
    failing = "\n".join(f"- {u}\n  {r['runs'][0][u][1][:1200]}" for u in r["failing"])
    prompt = PROMPT.format(release=common.RELEASE, clean=common.BASE, sha=c["sha"], subject=c["subject"],
                           injection=inj.decode("utf-8", "replace")[:20000], failing=failing)
    cmd = ["python3", os.path.join(common.TOOL, "guard.py"), "--timeout", str(a.timeout), "--rss-mb", "40000",
           "--log", os.path.join(slot, "notes", "agent.json"), "--cwd", slot, "--",
           "claude", "-p", "--model", a.model, "--settings", os.path.join(slot, "notes", ".settings.json"),
           "--setting-sources", "", "--strict-mcp-config", "--no-session-persistence",
           "--output-format", "json", "--max-budget-usd", str(a.budget), prompt]
    while not llm.credential_ok():
        time.sleep(120)
    t0 = time.time(); sh(cmd)
    txt = open(os.path.join(slot, "notes", "agent.json"), errors="replace").read()
    d = llm.parse_claude_json(txt)
    out["agent"] = {"cost": d.get("total_cost_usd") or 0.0, "secs": round(time.time() - t0), "num_turns": d.get("num_turns"),
                    "result": (d.get("result") or "")[-1500:], "model": list(d.get("modelUsage", {}).keys())}
    if not d:
        out["agent"]["cost"] = a.budget; out["agent"]["cost_estimated"] = True  # no usage printed: book the cap
    llm.record({"stage": "repro", "cost": out["agent"]["cost"], "ok": bool(d), "sha": c["sha"], "model": a.model,
                "estimated": bool(out["agent"].get("cost_estimated"))})
    shutil.copy(os.path.join(slot, "notes", "agent.json"), os.path.join(rdir, "repro-agent.json"))
    p = os.path.join(slot, "notes", "repro.sql")
    sql = open(p).read() if os.path.exists(p) else ""
    if d.get("is_error") and llm.is_api_error(d.get("result")):
        out["verdict"] = "infra"
    elif not d:
        out["verdict"] = "agent-timeout" if out["agent"]["secs"] >= a.timeout - 5 else "infra"
    elif not sql.strip() or sql.strip().startswith("-- NOT FOUND"):
        out["verdict"] = "not-found"; out["note"] = sql[:300]
    else:
        v = repro.verify(sql, common.BASE, src)   # harness verification
        out["verify"] = {k: v[k] for k in v if k != "clean_out"} | ({"clean_out": v["clean_out"]} if "clean_out" in v else {})
        out["verdict"] = "accepted" if v["ok"] else "rejected"
        if v["ok"]:
            open(os.path.join(rdir, "repro.sql"), "w").write(sql)
            r["repro"] = dict(v, sql=sql, method="agent", source="agent:" + a.model)
            common.write_json(a.result, r)
    common.sync_tree(src)
    return out, rdir


if __name__ == "__main__":
    o, rdir = main()
    common.write_json(os.path.join(rdir, "repro-agent-result.json"), o)
    print(o["verdict"], o.get("agent", {}).get("cost"))
