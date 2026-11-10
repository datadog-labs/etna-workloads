#!/usr/bin/env python3
"""Adapted-injection and reproducer agents.

  agents.py adapted --sha S [S...] | --auto N   [--model sonnet] [--workers 3]
  agents.py repro   --bug DIR [DIR...] | --auto N [--model sonnet] [--workers 3]

Each agent runs headless in the Claude sandbox (writes only its work dir,
no outbound network, local ports allowed). Results are verified by the
harness (gate.py / repro.py), never taken from the agent's word.
"""
import argparse, json, os, shutil, subprocess, sys, tarfile, time
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import agentlib, gate, inject, repro, tstree

W = tstree.WORK
TOOLS = os.path.dirname(os.path.abspath(__file__))
REPO = gate.REPO
ADIR = os.path.join(W, "agents")
HEREBY_ERA = 1667779200  # 2022-11-07: modules + hereby; older revisions need the gulp build

SANDBOX = {
    "sandbox": {"enabled": True, "autoAllowBashIfSandboxed": True, "allowUnsandboxedCommands": False,
                "network": {"allowLocalBinding": True, "allowedDomains": []}},
    "permissions": {"allow": ["Bash", "Read", "Edit", "Write", "Glob", "Grep"],
                    "deny": ["WebFetch", "WebSearch",
                             f"Edit(/{tstree.BASE}/**)", f"Write(/{tstree.BASE}/**)",
                             f"Edit(/{TOOLS}/**)", f"Write(/{TOOLS}/**)"]},
}

ADAPTED_TASK = """# Task: re-inject a historical TypeScript compiler bug into today's code

You are helping build a benchmark of realistic bugs for evaluating testing tools.
`tree/` is a full copy of the TypeScript compiler at release v6.0.3 (built). Long ago, upstream
commit {sha} fixed a bug:

    {subject}

`fix.diff` is that commit's implementation diff (the code it changed), `fix_tests.txt` lists its
test files (and `fix_tests.diff` shows them, possibly truncated). Simply reverse-applying the fix
to today's code {why}.

Your job: edit today's implementation in `tree/src/` so the bug the fix removed comes back, the
way it would look if the fix had never been made to today's code.

Rules (the harness checks them; a violation discards your work):
1. Change only implementation files: `tree/src/compiler/`, `tree/src/services/` (other `tree/src/`
   implementation dirs such as `src/server/` only if the fix touched them). Never change tests,
   baselines, `src/testRunner/`, `src/harness/`, `src/lib/`, build files or anything outside `tree/src/`.
2. Every changed hunk must correspond to a hunk of the fix: re-express the fix's removed behaviour in
   today's code. Do not invent a different bug, do not break unrelated behaviour, keep the change
   minimal. Preserve the files' CRLF line endings (edit with the Edit tool; do not rewrite files
   with tools that normalise newlines).
3. The tree must still build (the build includes a full type-check).
4. Success = at least one oracle case fails, ideally the cases marked [fix-added] (tests the fix
   itself added). The oracle cases are in `oracle.json`; they all pass on the unmodified tree.

Your loop: edit, then run `./check.sh` (rebuilds, about 30-60 s, then runs the oracle cases and prints
PASS/FAIL per case, plus the first failure messages). Actual outputs of failing baseline tests
are written to `tree/tests/baselines/local/` and the expected ones are in
`tree/tests/baselines/reference/`; compare them to confirm the failure is the bug's symptom.
Iterate until it fails for the right reason, or conclude that the bug cannot be re-expressed
(for example the code was rewritten so the bug cannot exist any more); then stop and say so.

When done, write `RATIONALE.md` in this directory: for each hunk you changed, which hunk of
`fix.diff` it corresponds to and why it brings back the same faulty behaviour; then the final
./check.sh summary line. Keep notes of what you tried in `NOTES.md` as you go.
"""

REPRO_TASK = """# Task: write a standalone reproducer for an injected TypeScript compiler bug

Two builds of the TypeScript compiler v6.0.3 are available:
- clean:    {clean}/built/local/tsc.js  and  {clean}/built/local/typescript.js
- injected: {inj}/built/local/tsc.js    and  {inj}/built/local/typescript.js
The injected build has the bug in `injection.patch` (it reintroduces a bug fixed upstream by
"{subject}"). Test cases of the compiler's own test suite that fail on the injected build are
listed in `failing_cases.txt`; `failing_baselines/` holds diffs of expected vs actual output of
those tests and their source `.ts` files when available.

Write a reproducer in `repro/`:
- `repro/repro.sh` (bash) plus any input files (e.g. `input.ts`, `tsconfig.json`, a `.mjs` script).
- It is run with cwd = a fresh copy of `repro/` and env vars `TSC` (path to tsc.js, run it with
  `node "$TSC" ...`) and `TYPESCRIPT` (path to typescript.js, for API or language-service scripts:
  `require(process.env.TYPESCRIPT)`).
- It must print the observable behaviour (emitted JS / .d.ts via `cat`, diagnostics, types, a
  language-service result) so that output or exit status differs between the clean and the
  injected build, and is deterministic. Keep it small: one input file if possible.
- Use only the public `tsc` command line or the public API of typescript.js (e.g.
  `ts.createProgram`, `ts.transpileModule`, `ts.createLanguageService` with a small in-memory
  host for editor features such as quick info, completions, find references, code fixes). Do not
  load or patch compiler internals or bundles other than typescript.js, and do not build or graft
  AST nodes by hand: the input must be ordinary source code a user could write.
- Forbidden: printing versions, hashing or inspecting the compiler files, timestamps, randomness,
  absolute paths. The difference must come from the compiler's behaviour on your input.

Check it with `./check_repro.sh` (runs it twice on clean, once on injected, and says whether it
is verified). Iterate until verified. Then write `repro/NOTES.md` with 2-4 lines: what the input
does and what differs (clean vs injected).
"""


def write(path, text, mode="w"):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, mode) as f:
        f.write(text)


def git_out(*a):
    return subprocess.run(["git", "-C", REPO, *a], capture_output=True, check=True).stdout


def run_agent(wd, task, stage, model, budget, timeout):
    agentlib.check_cap(stage, reserve=budget)
    settings = os.path.join(wd, ".agent-settings.json")
    json.dump(SANDBOX, open(settings, "w"))
    env = dict(os.environ)
    env["TMPDIR"] = os.path.join(wd, ".tmp")
    os.makedirs(env["TMPDIR"], exist_ok=True)
    data = agentlib.claude(["--model", model, "--settings", settings, "--permission-mode", "acceptEdits",
                            "--strict-mcp-config", "--no-session-persistence", "--max-budget-usd", str(budget),
                            task], wd, stage, timeout=timeout, log_path=os.path.join(wd, "agent.log"),
                           meta={"wd": os.path.basename(wd), "model": model, "budget": budget},
                           env=env, rss_mb=16384)
    keep = {k: data.get(k) for k in ("result", "total_cost_usd", "num_turns", "is_error", "retryable",
                                      "why", "killed", "subtype", "duration_ms")}
    json.dump(keep, open(os.path.join(wd, "agent_result.json"), "w"), indent=1)
    return keep


# --- adapted ---------------------------------------------------------------

def adapted_job(c, units, base_pass, model, budget, stage="adapted"):
    sha = c["sha"]
    wd = os.path.join(ADIR, stage, sha[:12])
    res_dir = os.path.join(W, stage, sha[:12])
    if os.path.exists(os.path.join(res_dir, "result.json")):
        st = json.load(open(os.path.join(res_dir, "result.json")))
        if st.get("status") not in ("retryable", "error"):
            return st
    tstree.rm_tree(wd)
    os.makedirs(wd)
    oracle = gate.oracle_for(units, base_pass)
    if not oracle:
        return {"name": sha[:12], "status": "no_oracle"}
    json.dump(oracle, open(f"{wd}/oracle.json", "w"), indent=1)
    tstree.mk_tree(os.path.join(wd, "tree"))
    open(f"{wd}/fix.diff", "wb").write(git_out("show", "--format=commit %H%nDate: %cI%n%n%B", sha, "--",
                                                 *c["impl_files"]).replace(b"\r", b""))
    tdiff = git_out("show", "--format=", sha, "--", *c["test_files"]).replace(b"\r", b"")
    open(f"{wd}/fix_tests.diff", "wb").write(tdiff[:150000] + (b"\n[truncated]\n" if len(tdiff) > 150000 else b""))
    write(f"{wd}/fix_tests.txt", "\n".join(c["test_files"]) + "\n")
    write(f"{wd}/check.sh", f'#!/bin/bash\nexec python3 {TOOLS}/agentcheck.py "$(dirname "$0")/tree" '
                            f'"$(dirname "$0")/oracle.json" "$@"\n')
    os.chmod(f"{wd}/check.sh", 0o755)
    vr = os.path.join(W, "verbatim", sha[:12], "result.json")
    why = "does not apply (the code has changed since)"
    if os.path.exists(vr):
        v = json.load(open(vr))
        why = {"no_failure": "applies but no longer makes any test fail",
               "build_failed": "applies but no longer builds"}.get(v["status"], why)
    task = ADAPTED_TASK.format(sha=sha, subject=c["subject"], why=why)
    write(f"{wd}/TASK.md", task)
    t0 = time.time()
    ar = run_agent(wd, "Read TASK.md in the current directory and carry it out.\n\n" + task,
                   stage, model, budget, timeout=90 * 60)
    result = {"name": sha[:12], "agent": ar, "agent_seconds": round(time.time() - t0)}
    if ar.get("retryable"):
        result["status"] = "retryable"
        os.makedirs(res_dir, exist_ok=True)
        json.dump(result, open(f"{res_dir}/result.json", "w"), indent=1)
        return result
    # Harness verification in a fresh tree.
    agent_tree = os.path.join(wd, "tree")
    paths = inject.changed_impl_files(agent_tree)
    patch = inject.make_patch(agent_tree, paths) if paths else b""
    os.makedirs(res_dir, exist_ok=True)
    for f in ("RATIONALE.md", "NOTES.md"):
        if os.path.exists(f"{wd}/{f}"):
            shutil.copy(f"{wd}/{f}", f"{res_dir}/{f}")
    open(f"{res_dir}/agent_patch.patch", "wb").write(patch)

    def prep(tree):
        if not patch:
            return False, {"method": "agent", "out": "agent made no change"}
        ok, method, out = inject.apply_patch(tree, patch)
        return ok, {"method": "agent", "out": out.decode(errors="replace")[-2000:]}
    g = gate.gate(f"{stage}-{sha[:12]}", res_dir, prep, units, base_pass)
    g["agent"] = ar
    g["agent_seconds"] = result["agent_seconds"]
    g["has_rationale"] = os.path.exists(f"{res_dir}/RATIONALE.md")
    g["check_runs"] = len([f for f in os.listdir(f"{wd}/check-logs") if f.startswith("tests-")]) \
        if os.path.isdir(f"{wd}/check-logs") else 0
    g["check_builds"] = len([f for f in os.listdir(f"{wd}/check-logs") if f.startswith("build-")]) \
        if os.path.isdir(f"{wd}/check-logs") else 0
    json.dump(g, open(f"{res_dir}/result.json", "w"), indent=1)
    # Keep the agent's logs, drop its tree.
    tstree.rm_tree(agent_tree)
    return g


# --- reproducer ------------------------------------------------------------

def repro_job(bug_dir, subject, model, budget):
    name = os.path.basename(bug_dir.rstrip("/"))
    kind = os.path.basename(os.path.dirname(bug_dir.rstrip("/")))
    wd = os.path.join(ADIR, "repro", f"{kind}-{name}")
    out = os.path.join(bug_dir, "repro_result.json")
    if os.path.exists(out) and json.load(open(out)).get("status") not in ("retryable", "error"):
        return json.load(open(out))
    tstree.rm_tree(wd)
    os.makedirs(wd)
    r = json.load(open(os.path.join(bug_dir, "result.json")))
    patch = open(os.path.join(bug_dir, "injection.patch"), "rb").read()
    inj = os.path.join(wd, "injected")
    tstree.mk_tree(inj)
    ok, _, _ = inject.apply_patch(inj, patch)
    if not ok or not tstree.build(inj, os.path.join(wd, "injected-build.log"))[0]:
        res = {"status": "error", "why": "injected build failed"}
        json.dump(res, open(out, "w"), indent=1)
        return res
    import filecmp
    if filecmp.cmp(os.path.join(inj, "built/local/typescript.js"),
                   os.path.join(tstree.BASE, "built/local/typescript.js"), shallow=False) and \
            any(p.startswith(("src/compiler/", "src/services/")) for p in r.get("files", [])):
        res = {"status": "error", "why": "injected typescript.js identical to base (stale build)"}
        json.dump(res, open(out, "w"), indent=1)
        return res
    shutil.copy(os.path.join(bug_dir, "injection.patch"), wd)
    write(f"{wd}/failing_cases.txt", "\n".join(r["failing"]) + "\n")
    fb = os.path.join(wd, "failing_baselines")
    os.makedirs(fb)
    tgz = os.path.join(bug_dir, "local_baselines.tgz")
    if os.path.exists(tgz):
        with tarfile.open(tgz) as t:
            t.extractall(os.path.join(wd, ".lb"), filter="data")
        lb = os.path.join(wd, ".lb", "tests/baselines/local")
        for dp, _, fs in os.walk(lb):
            for f in fs:
                rel = os.path.relpath(os.path.join(dp, f), lb)
                ref = os.path.join(tstree.BASE, "tests/baselines/reference", rel)
                d = subprocess.run(["diff", "-u", ref if os.path.exists(ref) else "/dev/null",
                                    os.path.join(dp, f)], capture_output=True).stdout
                write(os.path.join(fb, rel.replace("/", "__") + ".diff"), d[:40000].decode(errors="replace"))
        shutil.rmtree(os.path.join(wd, ".lb"), ignore_errors=True)
    for t in r["failing"][:20]:
        for tok in t.split():
            dst = os.path.join(fb, os.path.basename(tok))
            if tok.startswith("tests/cases/") and os.path.exists(os.path.join(tstree.BASE, tok)) \
                    and not os.path.exists(dst):
                shutil.copyfile(os.path.join(tstree.BASE, tok), dst)
    write(f"{wd}/check_repro.sh", f'#!/bin/bash\ncd "$(dirname "$0")"\nexport ETNA_SCRATCH="$PWD/.tmp"\nexec python3 {TOOLS}/repro.py check repro '
                                  f'{tstree.BASE} {inj} .check_result.json\n')
    os.chmod(f"{wd}/check_repro.sh", 0o755)
    os.makedirs(f"{wd}/repro")
    task = REPRO_TASK.format(clean=tstree.BASE, inj=inj, subject=subject)
    write(f"{wd}/TASK.md", task)
    ar = run_agent(wd, "Read TASK.md in the current directory and carry it out.\n\n" + task,
                   "repro", model, budget, timeout=45 * 60)
    res = {"agent": ar}
    if ar.get("retryable"):
        res["status"] = "retryable"
    elif not os.path.exists(f"{wd}/repro/repro.sh"):
        res["status"] = "no_repro"
    else:
        v = repro.check(f"{wd}/repro", tstree.BASE, inj)
        res["status"] = "verified" if v["verified"] else "unverified"
        res["check"] = {k: v.get(k) for k in ("verified", "why", "exit_differs", "output_differs", "clean2_same")}
        dst = os.path.join(bug_dir, "repro")
        shutil.rmtree(dst, ignore_errors=True)
        shutil.copytree(f"{wd}/repro", dst, symlinks=False)
        if v["verified"]:
            write(f"{dst}/expected_clean.txt", f"exit={v['clean']['rc']}\n{v['clean']['out']}")
            write(f"{dst}/expected_injected.txt", f"exit={v['injected']['rc']}\n{v['injected']['out']}")
    json.dump(res, open(out, "w"), indent=1)
    tstree.rm_tree(inj)
    return res


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("kind", choices=["adapted", "repro"])
    ap.add_argument("--sha", nargs="*")
    ap.add_argument("--bug", nargs="*")
    ap.add_argument("--model", default="sonnet")
    ap.add_argument("--budget", type=float)
    ap.add_argument("--workers", type=int, default=3)
    a = ap.parse_args()
    cands = {c["sha"]: c for c in map(json.loads, open(f"{W}/candidates.jsonl"))}
    if a.kind == "adapted":
        units = json.load(open(f"{W}/units_all.json"))
        base_pass = gate.load_base()
        todo = [cands[s] for s in cands if any(s.startswith(x) for x in a.sha or [])]
        todo.sort(key=lambda c: -c["time"])
        f = lambda c: adapted_job(c, units[c["sha"]], base_pass, a.model, a.budget or 3.0)
    else:
        by12 = {s[:12]: c for s, c in cands.items()}
        todo = a.bug or []
        f = lambda d: repro_job(d, by12[os.path.basename(d.rstrip("/"))]["subject"], a.model, a.budget or 1.5)
    with ThreadPoolExecutor(a.workers) as ex:
        for r in ex.map(f, todo):
            print(json.dumps({k: r.get(k) for k in ("name", "status", "failing_added", "has_rationale",
                                                     "check_runs", "check")} | {"cost": (r.get("agent") or {}).get("total_cost_usd")}),
                  flush=True)


if __name__ == "__main__":
    main()
