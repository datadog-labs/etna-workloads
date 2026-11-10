#!/usr/bin/env python3
"""Adapted tier: an agent re-expresses the fix's bug in today's code.

usage: adapted.py [--slots 0,1,2] [--cap USD] [--limit N] [--only C...] [--model M]
Each agent works in its own build slot (a writable release worktree).  The
harness then takes the slot's diff and re-verifies it with the same gate as
the verbatim tier.  Results: data/adapted/<commit>.json (resumable).
"""
import argparse
import json
import os
import queue
import shutil
import subprocess
import sys
import threading

sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, RELEASE, WORK, InfraError, git, is_impl, save_result  # noqa: E402
import agent  # noqa: E402
import llm  # noqa: E402
import oracle  # noqa: E402
import slot as slotmod  # noqa: E402
import verbatim  # noqa: E402

OUT = os.path.join(DATA, "adapted")
AGENTS = os.path.join(WORK, "agents")

PROMPT = """You are helping build a benchmark of realistic compiler bugs for evaluating testing tools.
Each benchmark bug is a historical rustc bug re-injected into a fixed release. Your job: re-inject
the bug fixed by one upstream commit into the Rust 1.99.1 source tree, adapting it to today's code.

## The upstream fix
Commit {commit} ({date}), PR https://github.com/rust-lang/rust/pull/{pr}{issues}
Subject: {subject}

{message}

The full fix diff (implementation and tests) is in {wd}/fix.diff. Its implementation part does not
cleanly reverse on 1.99.1 (or reversing it no longer makes the fix's tests fail):
{why}

## Your workspace
- Source tree (1.99.1, git worktree, already built at stage 1): {slot}
  Edit ONLY implementation files under {slot}/compiler/ (Rust sources, .ftl message files).
  Never edit tests (tests/, any tests.rs or */tests/* inside compiler), Cargo.toml, build files,
  library/ or src/.
- Build (incremental, usually under 2 minutes):
    cd {slot} && ./x build --stage 1 --keep-stage-std 1 compiler/rustc
- Run the oracle tests (compiletest; prints one `test [suite] path ... ok/FAILED` line per case):
    cd {slot} && ./x test --stage 1 --keep-stage-std 1 --force-rerun {oracle_files}
  Oracle cases (they pass on the clean release; the ones marked * were added by the fix itself):
{oracle_list}
- `git -C {slot} diff` shows your changes. The shell is zsh (no PIPESTATUS). An untracked `.mcp.json`
  may appear in `git status` inside your sandbox: it is a sandbox artifact, ignore it.
- You have no network access. Write notes only in {wd}.

## What to do
1. Read fix.diff and understand the bug the fix removed (the parent commit's behaviour).
2. Find where that logic lives in 1.99.1 (it may have moved or been rewritten) and change the
   implementation so the old, buggy behaviour comes back. Every hunk you change must trace to a
   hunk of the fix: re-express what the fix changed, do not invent a different bug, and do not
   break unrelated functionality (no blanket panics, no disabling whole passes).
3. Build, then run the oracle tests. Goal: at least one oracle case FAILS, preferably one marked *,
   while the compiler still builds. Iterate if needed.
4. Leave your changes in the source tree (do not revert or commit them) and write:
   - {wd}/RATIONALE.md: for each hunk you changed: file and function, what it does, and which hunk of
     fix.diff it re-expresses (quote that fix hunk's @@ header and key lines).
   - {wd}/NOTES.md: the build and test commands you ran and their final result lines (copy the
     `test [...] ... ok/FAILED` lines and `test result:` lines from the last run).
If after honest effort you cannot make an oracle case fail with a faithful re-expression, revert your
changes (`git -C {slot} diff | git -C {slot} apply -R`; git checkout cannot write the worktree's
metadata in your sandbox) and explain why in NOTES.md.
"""


def reverse_report(c):
    fix = git("diff", "--no-renames", f"{c['commit']}^", c["commit"], "--", *c["impl_files"])
    tree = os.path.join(WORK, "probe-1.99.1")
    r = subprocess.run(["patch", "-R", "-p1", "--dry-run", "-F3", "-f", "-i", "-"], cwd=tree,
                       input=fix, capture_output=True, text=True)
    out = (r.stdout + r.stderr).strip().splitlines()
    return "\n".join("    " + line for line in out[:40])


def select(cands, probe, triage, orcs, vres):
    out = []
    for h, c in cands.items():
        t = triage.get(h)
        if not t or t["label"] != "bug":
            continue
        o = orcs.get(h)
        if not o or not o["cases"]:
            continue
        if not any(o["added"].get(k.split("#")[0]) for k in o["cases"]):
            continue  # cannot become strict
        st = probe[h]["status"]
        v = vres.get(h)
        if st in ("partial", "conflict") or (v and v["status"] in (
                "no_failure", "apply_failed", "build_failed", "controls_failed")):
            out.append(h)
    out.sort(key=lambda h: cands[h]["date"], reverse=True)
    return out


def load_dir(d):
    res = {}
    if os.path.isdir(d):
        for f in os.listdir(d):
            if f.endswith(".json"):
                res[f[:-5]] = json.load(open(os.path.join(d, f)))
    return res


def run_one(c, slot, orc, probe, vres, model, max_budget, stage="adapted"):
    h = c["commit"]
    wd = os.path.join(AGENTS, h)
    shutil.rmtree(wd, ignore_errors=True)
    os.makedirs(wd)
    open(os.path.join(wd, "fix.diff"), "w").write(git("show", "--format=", h))
    slotmod.reset(slot)
    added = orc["added"]
    files = sorted({k.split("#")[0] for k in orc["cases"]})
    v = vres.get(h)
    why = (f"    verbatim reversal applied but: {v['status']}" if v and v["status"] != "apply_failed"
           else reverse_report(c))
    prompt = PROMPT.format(
        commit=h, date=c["date"][:10], pr=c.get("pr"), subject=c["subject"],
        issues="".join(f", issue https://github.com/rust-lang/rust/issues/{n}" for n in c["issue_refs"][:3]),
        message=c["body"][:3000], wd=wd, why=why, slot=slot, oracle_files=" ".join(files),
        oracle_list="\n".join(f"    {'*' if added.get(k.split('#')[0]) else ' '} {k}" for k in orc["cases"][:60]))
    open(os.path.join(wd, "PROMPT.md"), "w").write(prompt)
    a = agent.launch(prompt, wd, stage, h, writable=[slot],
                     readable=[os.path.join(WORK, "probe-1.99.1")], model=model, max_budget=max_budget)
    res = dict(commit=h, date=c["date"], subject=c["subject"], model=model, agent=a)
    if a["api_error"]:
        res["status"] = "api_error"  # retryable
        slotmod.reset(slot)
        return res
    inj = subprocess.run(["git", "diff", "--full-index", "--", "compiler"], cwd=slot,
                         capture_output=True, text=True).stdout
    untracked = [x for x in slotmod.dirty(slot) if x.startswith("??")]
    files_changed = sorted({line[6:] for line in inj.splitlines() if line.startswith(("+++ b/", "--- a/"))}
                           - {"/dev/null"})
    res["files_changed"] = files_changed
    res["untracked"] = untracked
    notes = os.path.join(OUT, "notes", h)
    os.makedirs(notes, exist_ok=True)
    for f in ("RATIONALE.md", "NOTES.md", "PROMPT.md"):
        if os.path.exists(os.path.join(wd, f)):
            shutil.copy(os.path.join(wd, f), notes)
    slotmod.reset(slot)
    if not inj.strip():
        res["status"] = "agent_gave_up"
        return res
    if not all(is_impl(p) for p in files_changed):
        res["status"] = "non_impl_injection"
        return res
    open(os.path.join(notes, "agent.patch"), "w").write(inj)
    g = verbatim.process(c, slot, orc, patch=inj, outdir=OUT, tag="-adapted")
    res["gate"] = {k: g.get(k) for k in ("status", "apply", "build_secs", "failing", "failing_added_by_fix",
                                          "restore_ok", "controls_failed", "excerpts", "runs", "oracle")}
    res["status"] = g["status"]
    fix_files = set(c["impl_files"])
    crates = {p.split("/")[1] for p in fix_files}
    res["locality"] = ("same-files" if set(files_changed) <= fix_files else
                       "overlapping" if set(files_changed) & fix_files else
                       "same-crates" if {p.split("/")[1] for p in files_changed} <= crates else "disjoint")
    res["has_rationale"] = os.path.exists(os.path.join(notes, "RATIONALE.md"))
    shutil.rmtree(wd, ignore_errors=True)
    return res


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--slots", default="0,1,2")
    ap.add_argument("--cap", type=float, default=0.0)
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--only", nargs="*")
    ap.add_argument("--model", default=agent.MODEL)
    ap.add_argument("--max-budget", type=float, default=4.0)
    ap.add_argument("--retry-api-errors", action="store_true")
    ap.add_argument("--retry-statuses", help="comma list: re-attempt earlier results with these statuses")
    ap.add_argument("--stage", default="adapted")
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    cands = {json.loads(line)["commit"]: json.loads(line) for line in open(os.path.join(DATA, "candidates.jsonl"))}
    probe = {json.loads(line)["commit"]: json.loads(line) for line in open(os.path.join(DATA, "probe.jsonl"))}
    triage = load_dir(os.path.join(DATA, "triage"))
    vres = load_dir(os.path.join(DATA, "verbatim"))
    orcs = oracle.load()
    done = load_dir(OUT)
    todo = select(cands, probe, triage, orcs, vres)
    if a.only:
        todo = [h for h in cands if any(h.startswith(x) for x in a.only)]
    if a.retry_statuses:
        want = set(a.retry_statuses.split(","))
        todo = [h for h in todo if h in done and done[h]["status"] in want and not done[h].get("previous")]
    else:
        todo = [h for h in todo if h not in done or (a.retry_api_errors and done[h]["status"] == "api_error")]
    if a.limit:
        todo = todo[:a.limit]
    print(f"{len(todo)} adapted candidates; spent so far {llm.spent(a.stage):.2f}", flush=True)
    q = queue.Queue()
    for h in todo:
        q.put(h)
    lock = threading.Lock()

    def worker(n):
        s = slotmod.path(n)
        while True:
            with lock:
                if a.cap and llm.spent(a.stage) >= a.cap:
                    return
            try:
                h = q.get_nowait()
            except queue.Empty:
                return
            try:
                r = run_one(cands[h], s, orcs[h], probe, vres, a.model, a.max_budget, a.stage)
                if h in done and done[h]["status"] != "api_error":
                    r["previous"] = done[h]
            except OSError as e:  # e.g. ENOSPC while writing notes: not a result
                print(f"OS ERROR, worker {n} stops: {e}", flush=True)
                return
            except verbatim.SlotBroken as e:
                print(f"SLOT BROKEN, worker {n} stops: {e}", flush=True)
                return
            try:
                save_result(os.path.join(OUT, f"{h}.json"), r)
            except InfraError as e:
                print(f"INFRA ERROR, worker {n} stops: {e}", flush=True)
                return
            with lock:
                print(f"{h[:10]} {r['date'][:10]} slot{n} {r['status']:<16} "
                      f"fail={len((r.get('gate') or {}).get('failing') or [])} "
                      f"strict-case={len((r.get('gate') or {}).get('failing_added_by_fix') or [])} "
                      f"${r['agent']['cost']:.2f} {r['agent']['secs']}s {r.get('locality', '')} "
                      f"{r['subject'][:40]}", flush=True)

    ts = [threading.Thread(target=worker, args=(int(n),)) for n in a.slots.split(",")]
    for t in ts:
        t.start()
    for t in ts:
        t.join()


if __name__ == "__main__":
    _ = RELEASE
    main()
