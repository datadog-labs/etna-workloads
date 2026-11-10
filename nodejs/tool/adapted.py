#!/usr/bin/env python3
"""Adapted tier: an agent re-expresses a fix's bug in today's code; the harness gates it.

Per candidate (newest first):
  1. agent runs in a pristine agent slot (real writable copy, own build), sandboxed;
     it edits lib/ and src/, builds, runs the oracle tests, writes RATIONALE.md
  2. harness takes the injection = slot lib/src diff vs pristine (symlinks ignored),
     saves RATIONALE.md, records any other files the agent touched, restores the slot
  3. harness gates the injection in a clean gate slot (gate.gate_one, tier=adapted)
Anchors are computed separately (anchor.py).  Resumable; spend-capped.
"""
import argparse, json, os, queue, subprocess, sys, threading, time, traceback
import agents, gate, llm, slot as S

PROMPT = """You are helping build a benchmark of real, historical bugs in Node.js for evaluating
testing tools. Each benchmark bug is a real upstream fix whose bug is re-introduced into a
fixed release. Your job: re-introduce the bug fixed by one upstream commit into the
Node.js v26.13.0 source tree in your current directory.

The tree is already configured and built (debug-node build, binary: out/Release/node).

## The upstream fix
Commit {sha} ({date})
{message}

Full diff of the fix (implementation and tests) at the time it landed:
<fix_diff>
{diff}
</fix_diff>

## Why the plain reversal is not enough
{why}

## What to do
1. Study how the code the fix touched looks today (the release has moved on since the fix).
2. Edit ONLY implementation files under lib/ and src/ so that the release behaves the way the
   code behaved before the fix, i.e. bring back the defect the fix removed. Keep the change
   minimal and in the spirit of the fix: every hunk you write must correspond to a hunk of
   the fix (re-expressed for today's code). Do not add unrelated breakage, do not break the
   build, and do not touch tests, test fixtures, build files (node.gyp, *.gypi, configure,
   Makefile) or files outside lib/ and src/.
3. Build and test:
     make -j8 && python3 tools/test.py -p tap -j 4 --shell out/Release/node --temp-dir {scratch} {units}
   (incremental build, ~1-2 min; C++ and lib/ changes both need it; always check that the build
   succeeded, otherwise you are testing a stale binary.)
   These test cases pass on the clean release; at least one of them must FAIL with your change
   (fail = "not ok" in the TAP output) because of the re-introduced bug. Run the tests at least
   twice at the end to make sure the failure is stable.
   The oracle cases: {cases}
4. Write RATIONALE.md in the current directory with: a one-paragraph description of the bug;
   for each hunk of your change, which hunk of the fix it corresponds to and why it brings
   back the old behaviour; the test cases that fail with your change and the failure message.
If, after a real attempt, the bug cannot be re-introduced faithfully (e.g. the code was
removed or rewritten so that the old defect no longer makes sense), restore the files you
changed under lib/ and src/ and say so in RATIONALE.md instead of inventing a different bug.
No network access is available; local ports work.
"""

MAX_DIFF = 60000


def why_text(c, vres):
    if c["apply"] == "conflict" or (vres and vres.get("status") == "apply-fail"):
        return ("The reverse of the fix's implementation hunks does not apply to the release "
                "(the code has changed since).")
    if vres and vres.get("status") == "no-fail":
        return ("The reverse of the fix's implementation hunks applies, but none of the oracle "
                "test cases fails afterwards, so the reversal no longer brings the bug back "
                "(the behaviour may now be reached through different code).")
    if vres and vres.get("status") == "build-fail":
        return "The reverse of the fix's implementation hunks applies but does not build."
    return "The plain reversal did not produce a verified bug."


def fix_diff(c):
    d = subprocess.run(["git", "-C", gate.REPO, "show", "--format=", c["sha"], "--",
                        *c["impl_files"], *c["test_files"]],
                       capture_output=True, text=True, errors="replace").stdout
    if len(d) > MAX_DIFF:
        d = d[:MAX_DIFF] + f"\n[... diff cut, {len(d) - MAX_DIFF} more characters ...]"
    return d


def locality(inj_files, c):
    fix = set(c["impl_files"])
    inj = set(inj_files)
    if inj <= fix:
        return "same-files"
    if inj & fix:
        return "overlapping"
    if {os.path.dirname(f) for f in inj} & {os.path.dirname(f) for f in fix}:
        return "same-dir"
    return "disjoint"


def adapt_one(c, vres, aslot, gslot, base, args, gslot_lock):
    sha = c["sha"]
    out = {"sha": sha, "tier": "adapted"}
    oracle = [u for u in gate.expand_units(c["js_units"], base) + c["cc_units"]
              if base.get(u) == ["pass", "pass"]]
    if not oracle:
        out["status"] = "no-oracle"
        return out
    logdir = os.path.join(args.logroot, sha[:12])
    scratch = os.path.join(agents.SCRATCH, sha[:12])
    os.makedirs(scratch, exist_ok=True)
    js_units = sorted({gate.unit_of(u) for u in oracle if not u.startswith("cctest:")})
    cc = [u for u in oracle if u.startswith("cctest:")]
    units = " ".join(js_units)
    if cc:
        units += ("\n   C++ cases run with: out/Release/cctest --gtest_filter=" +
                  ":".join(x[len("cctest:"):] for x in cc) +
                  "  (build it with: make -j8 -C out BUILDTYPE=Release cctest)")
    body = c["body"]
    prompt = PROMPT.format(sha=sha, date=c["date"][:10], message=body, diff=fix_diff(c),
                           why=why_text(c, vres), scratch=scratch, units=units,
                           cases=", ".join(oracle))
    agents.restore_slot(aslot)  # paranoia: start from pristine sources
    if os.path.exists(os.path.join(aslot, "RATIONALE.md")):
        os.remove(os.path.join(aslot, "RATIONALE.md"))
    ar = agents.run_agent(aslot, prompt, args.model, args.agent_budget, args.max_turns,
                          args.wall, args.ledger, args.stage, logdir)
    out["agent"] = {k: v for k, v in ar.items() if k != "result"}
    open(os.path.join(logdir, "result.txt"), "w").write(ar.get("result", ""))
    try:
        if ar.get("retryable"):
            out["status"] = "retryable-error"
            return out
        rat = os.path.join(aslot, "RATIONALE.md")
        out["rationale"] = open(rat, errors="replace").read() if os.path.exists(rat) else None
        if out["rationale"]:
            open(os.path.join(logdir, "RATIONALE.md"), "w").write(out["rationale"])
        files = agents.changed_impl_files(aslot)
        out["other_changes"] = agents.other_changes(aslot)
        if not files:
            out["status"] = "agent-gave-up"
            return out
        inj = S.make_patch(aslot, files)
        open(os.path.join(logdir, "injection.patch"), "wb").write(inj)
        out["locality"] = locality(files, c)
    finally:
        agents.restore_slot(aslot)
        subprocess.run(["rm", "-rf", scratch])
    if not out["rationale"]:
        out["status"] = "no-rationale"
        return out
    with gslot_lock[gslot]:
        g = gate.gate_one(c, gslot, base, os.path.expanduser("~/node-etna-work/gatework"),
                          injection=inj, tier="adapted")
    out["gate"] = {k: v for k, v in g.items() if k not in ("sha", "tier")}
    out["status"] = "pass" if g["status"] == "pass" else "gate-" + g["status"]
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--inp", required=True)
    ap.add_argument("--triage", required=True)
    ap.add_argument("--verbatim", required=True, help="verbatim gate results (jsonl)")
    ap.add_argument("--base", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--ledger", required=True)
    ap.add_argument("--cap-usd", type=float, required=True, help="stage spend cap")
    ap.add_argument("--agent-slots", required=True)
    ap.add_argument("--gate-slots", required=True)
    ap.add_argument("--model", default=agents.AGENT_MODEL)
    ap.add_argument("--stage", default="adapted", help="ledger stage name (separate cap per stage)")
    ap.add_argument("--retry-of", help="results of an earlier adapted pass: retry its failures")
    ap.add_argument("--verbatim-failures-only", action="store_true",
                    help="only candidates whose verbatim reversal applied but did not build or fail")
    ap.add_argument("--agent-budget", type=float, default=4.0)
    ap.add_argument("--max-turns", type=int, default=120)
    ap.add_argument("--wall", type=int, default=3600)
    ap.add_argument("--limit", type=int)
    ap.add_argument("--only")
    ap.add_argument("--logroot", default=os.path.expanduser("~/node-etna-work/agentlogs/adapted"))
    a = ap.parse_args()
    base = json.load(open(a.base))["runs"]
    tri = {json.loads(l)["sha"]: json.loads(l) for l in open(a.triage)}
    ver = {}
    if os.path.exists(a.verbatim):
        for l in open(a.verbatim):
            r = json.loads(l)
            ver[r["sha"]] = r
    done = set()
    if os.path.exists(a.out):
        for l in open(a.out):
            r = json.loads(l)
            if r["status"] != "retryable-error":
                done.add(r["sha"])
    todo = []
    for l in open(a.inp):
        c = json.loads(l)
        if c["sha"] in done or tri.get(c["sha"], {}).get("label") != "bug":
            continue
        v = ver.get(c["sha"])
        if v and v["status"] == "pass":
            continue  # already a verbatim bug
        if c["apply"] != "conflict" and not v:
            continue  # verbatim not tried yet
        if not (c["js_units"] or c["cc_units"]):
            continue
        todo.append((c, v))
    if a.only:
        want = set(open(a.only).read().split())
        todo = [t for t in todo if t[0]["sha"] in want]
    if a.verbatim_failures_only:
        todo = [t for t in todo if t[1] and t[1]["status"] in ("no-fail", "build-fail")]
    if a.retry_of:
        # Retry (with a stronger model) earlier failures that could still become strict:
        # the agent gave up or its injection did not fail, and some oracle case was added by the fix.
        prev = {json.loads(l)["sha"]: json.loads(l) for l in open(a.retry_of)}
        keep = []
        for c, v in todo:
            p = prev.get(c["sha"])
            if not p or p["status"] not in ("agent-gave-up", "gate-no-fail", "no-rationale",
                                            "gate-apply-fail", "gate-build-fail"):
                continue
            oracle = [u for u in gate.expand_units(c["js_units"], base) + c["cc_units"]
                      if base.get(u) == ["pass", "pass"]]
            if gate.added_cases(c, oracle):
                keep.append((c, v))
        todo = keep
    todo.sort(key=lambda t: t[0]["date"], reverse=True)  # newest first
    if a.limit:
        todo = todo[:a.limit]
    print(f"adapted todo: {len(todo)}", flush=True)
    q = queue.Queue()
    for t in todo:
        q.put(t)
    gslots = a.gate_slots.split(",")
    gslot_lock = {g: threading.Lock() for g in gslots}
    lock = threading.Lock()

    def worker(i, aslot):
        gslot = gslots[i % len(gslots)]
        while True:
            if llm.spent(a.ledger, a.stage) >= a.cap_usd:
                print("adapted spend cap reached", flush=True)
                return
            if os.path.exists(gate.STOP_FILE):
                print("STOP file present; stopping cleanly", flush=True)
                return
            try:
                c, v = q.get_nowait()
            except queue.Empty:
                return
            try:
                r = adapt_one(c, v, aslot, gslot, base, a, gslot_lock)
            except Exception:
                r = {"sha": c["sha"], "tier": "adapted", "status": "error",
                     "error": traceback.format_exc()[-3000:]}
                try:
                    agents.restore_slot(aslot)
                except Exception as e:
                    print(f"FATAL: cannot restore {aslot}: {e}", flush=True)
                    return
            r["agent_slot"], r["date"], r["subject"] = os.path.basename(aslot), c["date"], c["subject"]
            with lock:
                with open(a.out, "a") as f:
                    f.write(json.dumps(r) + "\n")
                g = r.get("gate", {})
                print(f"{c['sha'][:10]} {r['status']:22} fail={len(g.get('failing', []))} "
                      f"${r.get('agent', {}).get('cost_usd', 0):.2f} {c['subject'][:60]}", flush=True)

    ts = [threading.Thread(target=worker, args=(i, s)) for i, s in enumerate(a.agent_slots.split(","))]
    for t in ts:
        t.start()
    for t in ts:
        t.join()
    print(f"{a.stage} spend so far: ${llm.spent(a.ledger, a.stage):.2f}", flush=True)


if __name__ == "__main__":
    main()
