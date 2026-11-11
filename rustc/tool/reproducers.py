#!/usr/bin/env python3
"""Reproducers for gate-passing bugs.

For each bug: build the injected compiler in a slot; first try an automatic
reproducer derived from a failing oracle test (single file, its compile flags);
if the harness does not confirm it, optionally ask an agent to write one.
Every reproducer is verified by repro.py (clean twice, injected twice).

usage: reproducers.py --tier verbatim|adapted [--slots 0,1,2] [--agent] [--cap USD] [--only ...]
Results: data/repro/<commit>.json and data/repro/<commit>/ (repro.sh, inputs, expected outputs).
"""
import argparse
import json
import os
import queue
import re
import shutil
import subprocess
import sys
import threading

sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, ROOT, WORK, InfraError, save_result  # noqa: E402
import agent  # noqa: E402
import llm  # noqa: E402
import repro  # noqa: E402
import memguard  # noqa: E402
import runner  # noqa: E402
import slot as slotmod  # noqa: E402

OUT = os.path.join(DATA, "repro")
BASE_RUSTC = os.path.join(WORK, "base/build/x86_64-unknown-linux-gnu/stage1/bin/rustc")
AGENTS = os.path.join(WORK, "agents")
DIRECTIVE = re.compile(r"^\s*//@\s*(?:\[([\w,-]+)\])?\s*([\w-]+)\s*(?::\s*(.*))?$")
UNSUPPORTED = ("aux-build", "aux-crate", "aux-bin", "proc-macro", "aux-codegen-backend",
               "incremental", "run-rustfix", "known-bug", "exec-env", "rustc-env")


def directives(text, rev):
    flags, edition, mode, bad = [], None, None, []
    for line in text.splitlines():
        m = DIRECTIVE.match(line)
        if not m:
            continue
        revs, name, val = m.group(1), m.group(2), (m.group(3) or "").strip()
        if revs and rev not in revs.split(","):
            continue
        if name == "compile-flags":
            flags += val.split()
        elif name == "edition":
            edition = val
        elif name in ("run-pass", "run-fail", "run-crash", "build-pass", "build-fail",
                      "check-pass", "check-fail"):
            mode = name
        elif name in UNSUPPORTED or name.startswith("aux"):
            bad.append(name)
    return flags, edition, mode, bad


def auto(case, slot_tree, dest):
    """Write an automatic reproducer for one failing case; returns why-not or None."""
    path, _, rev = case.partition("#")
    suite = path.split("/")[1]
    src = os.path.join(slot_tree, path)
    text = open(src, errors="replace").read()
    flags, edition, mode, bad = directives(text, rev)
    if bad:
        return f"unsupported directives {sorted(set(bad))}"
    if suite not in ("ui", "mir-opt", "codegen-llvm", "assembly-llvm", "crashes"):
        return f"suite {suite} not supported"
    flags = [f for f in flags if not f.startswith(("-Zui-testing",))]
    if any("/" in f for f in flags):
        return "flags reference paths"
    args = list(flags)
    if edition:
        args += ["--edition", edition]
    if rev:
        args += ["--cfg", rev]
    if "crate_type" not in text and "crate-type" not in " ".join(flags) and not re.search(r"\bfn\s+main\b", text):
        args += ["--crate-type=lib"]
    lines = ["#!/bin/bash", "# Auto-generated from " + case, "cd \"$(dirname \"$0\")\""]
    a = " ".join(args)
    if suite == "mir-opt":
        lines.append(f'"$RUSTC" {a} -Zmir-opt-level=1 --emit=mir -o - main.rs 2>&1; echo "rustc exit: $?"')
    elif suite == "codegen-llvm":
        lines.append(f'"$RUSTC" {a} --emit=llvm-ir -o - main.rs 2>&1; echo "rustc exit: $?"')
    elif suite == "assembly-llvm":
        lines.append(f'"$RUSTC" {a} --emit=asm -o - main.rs 2>&1; echo "rustc exit: $?"')
    elif mode in ("run-pass", "run-fail", "run-crash"):
        lines.append(f'"$RUSTC" {a} -o prog main.rs 2>&1; echo "rustc exit: $?"')
        lines.append('[ -x prog ] && { ./prog 2>&1; echo "program exit: $?"; }')
    elif mode in ("check-pass", "check-fail"):
        lines.append(f'"$RUSTC" {a} --emit=metadata -o out.rmeta main.rs 2>&1; echo "rustc exit: $?"')
    else:
        lines.append(f'"$RUSTC" {a} -o prog main.rs 2>&1; echo "rustc exit: $?"')
    lines.append('rm -f prog out.rmeta')
    os.makedirs(dest, exist_ok=True)
    shutil.copy(src, os.path.join(dest, "main.rs"))
    open(os.path.join(dest, "repro.sh"), "w").write("\n".join(lines) + "\n")
    return None


AGENT_PROMPT = """You are writing a standalone reproducer for an injected rustc bug (benchmark construction).

Two compilers are installed (both Rust 1.99.1 stage-1 builds, each with a full std sysroot):
- clean:    {clean}
- injected: {injected}   (1.99.1 with the bug below re-injected)
The injection (a patch to the compiler) is in {wd}/injection.patch; the upstream fix it undoes is
described in {wd}/BUG.md together with the compiletest case(s) that fail on the injected compiler
and their expected-vs-actual output. The test sources are under {tree}/tests (read-only).

Write a reproducer in {wd}/repro/: a bash script `repro.sh` plus at most a few small input files
(e.g. main.rs, an auxiliary crate source). The script must use only "$RUSTC" (the harness sets it
to one of the two compilers) and standard shell tools; it runs in a private copy of the repro/
directory, with no network. It should print what it observes (compiler output, exit statuses,
program output). Requirements, checked by the harness, not by you:
- output on the clean compiler is deterministic (identical over two runs);
- output and/or exit status on the injected compiler differs from the clean one (deterministically);
- no absolute paths, no `--version`/`-V`, no cargo, no git; do not print source or version identifiers.
Check it with:  REPRO_RUNS={wd}/runs python3 -I {tools}/repro.py {wd}/repro {clean} {injected}
(prints a JSON verdict with "ok": true when accepted). Keep it minimal and close to the bug.
When done, write {wd}/repro/README.md (one paragraph: what the reproducer shows).
"""


def bug_md(r, c):
    ex = "\n\n".join(f"### {k}\n```\n{v[:2500]}\n```" for k, v in (r.get("excerpts") or {}).items())
    return (f"# {c['subject']}\n\nFix commit {c['commit']} (PR #{c.get('pr')})\n\n{c['body'][:3000]}\n\n"
            f"## Failing compiletest cases on the injected compiler\n" +
            "\n".join(f"- {k}" for k in r["failing"]) + "\n\n## Excerpts (expected vs actual)\n" + ex + "\n")


class BuildTimeout(Exception):
    pass


def process(h, r, c, slot, use_agent, model):
    out = dict(commit=h)
    dest = os.path.join(OUT, h)
    shutil.rmtree(dest, ignore_errors=True)
    slotmod.reset(slot)
    patch = r["patch"]
    p = os.path.join(WORK, "tmp", f"{h}.repro.patch")
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "w").write(patch)
    if subprocess.run(["git", "apply", p], cwd=slot).returncode:
        out["status"] = "apply_failed"
        return out
    try:
        code, _ = runner.build(slot, os.path.join(WORK, "tmp", f"{h}.repro-build.log"))
        if code == "timeout":  # an incremental build never takes an hour on a healthy host
            raise BuildTimeout(h)
        if code != 0:
            out["status"] = "build_failed"
            return out
        code, _ = runner.populate_sysroot(slot, os.path.join(WORK, "tmp", f"{h}.repro-sysroot.log"))
        inj = os.path.join(slot, "build/x86_64-unknown-linux-gnu/stage1/bin/rustc")
        hc = repro.health(inj)
        if code != 0 or not hc["ok"]:
            out.update(status="injected_compiler_unhealthy", health=hc)
            return out
        added = set(r.get("failing_added_by_fix") or [])
        order = sorted(r["failing"], key=lambda k: (k not in added, k))
        tries = []
        for case in order[:4]:
            why = auto(case, slot, dest)
            if why:
                tries.append(dict(case=case, why=why))
                continue
            v = repro.check(dest, BASE_RUSTC, inj)
            tries.append(dict(case=case, ok=v["ok"], why=v["why"]))
            if v["ok"]:
                out.update(status="auto", case=case, verdict=v)
                save_expected(dest, v)
                return out
            shutil.rmtree(dest, ignore_errors=True)
        out["auto_tries"] = tries
        if not use_agent:
            out["status"] = "none"
            return out
        wd = os.path.join(AGENTS, "repro-" + h)
        shutil.rmtree(wd, ignore_errors=True)
        os.makedirs(os.path.join(wd, "repro"))
        open(os.path.join(wd, "injection.patch"), "w").write(patch)
        open(os.path.join(wd, "BUG.md"), "w").write(bug_md(r, c))
        prompt = AGENT_PROMPT.format(clean=BASE_RUSTC, injected=inj, wd=wd, tree=slot,
                                     tools=os.path.join(ROOT, "tools"))
        a = agent.launch(prompt, wd, "repro", h, writable=[], model=model, max_budget=1.5,
                         readable=[slot, os.path.join(WORK, "base"), os.path.join(ROOT, "tools")], timeout=2400)
        out["agent"] = a
        if a["api_error"]:
            out["status"] = "api_error"
            return out
        src = os.path.join(wd, "repro")
        v = repro.check(src, BASE_RUSTC, inj)  # harness verdict, not the agent's
        out["verdict"] = v
        if v["ok"]:
            shutil.copytree(src, dest)
            save_expected(dest, v)
            out["status"] = "agent"
        else:
            out["status"] = "agent_failed"
        shutil.rmtree(wd, ignore_errors=True)
        return out
    finally:
        slotmod.reset(slot)


def save_expected(dest, v):
    open(os.path.join(dest, "expected_clean.txt"), "w").write(v["clean"]["out"] + f"\n[exit {v['clean']['exit']}]\n")
    open(os.path.join(dest, "expected_injected.txt"), "w").write(
        v["injected"]["out"] + f"\n[exit {v['injected']['exit']}]\n")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--tier", required=True, choices=["verbatim", "adapted"])
    ap.add_argument("--slots", default="0,1,2")
    ap.add_argument("--agent", action="store_true")
    ap.add_argument("--cap", type=float, default=0.0)
    ap.add_argument("--model", default=agent.MODEL)
    ap.add_argument("--only", nargs="*")
    ap.add_argument("--limit", type=int, default=0)
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    cands = {json.loads(line)["commit"]: json.loads(line) for line in open(os.path.join(DATA, "candidates.jsonl"))}
    src = os.path.join(DATA, a.tier)
    bugs = {}
    for f in os.listdir(src):
        if not f.endswith(".json"):
            continue
        r = json.load(open(os.path.join(src, f)))
        if r["status"] != "gate_pass":
            continue
        g = r if a.tier == "verbatim" else dict(r["gate"], commit=r["commit"])
        g["patch"] = open(os.path.join(src, "patches", r["commit"] + ".patch")).read()
        bugs[r["commit"]] = g
    todo = sorted(bugs, key=lambda h: cands[h]["date"], reverse=True)
    if a.only:
        todo = [h for h in todo if any(h.startswith(x) for x in a.only)]
    def done(h):
        p = os.path.join(OUT, h + ".json")
        if not os.path.exists(p):
            return False
        s = json.load(open(p))["status"]
        return s in ("auto", "agent", "agent_failed") or (s == "none" and not a.agent)
    todo = [h for h in todo if not done(h)]
    if a.limit:
        todo = todo[:a.limit]
    print(f"{len(todo)} bugs need reproducers", flush=True)
    q = queue.Queue()
    for h in todo:
        q.put(h)
    lock = threading.Lock()
    timeouts = {}

    def worker(n):
        s = slotmod.path(n)
        while True:
            with lock:
                if a.cap and llm.spent("repro") >= a.cap:
                    use_agent = False
                else:
                    use_agent = a.agent
            try:
                h = q.get_nowait()
            except queue.Empty:
                return
            try:
                res = process(h, bugs[h], cands[h], s, use_agent, a.model)
            except BuildTimeout:
                with lock:
                    timeouts[h] = timeouts.get(h, 0) + 1
                    again = timeouts[h] < 2
                print(f"{h[:10]} slot{n} build timed out, not recorded" + ("; re-queued" if again else ""),
                      flush=True)
                if not again:
                    print(f"INFRA ERROR, worker {n} stops: build of {h[:10]} timed out twice", flush=True)
                    return
                memguard.wait_for_memory(memguard.GB["build"], "build")
                q.put(h)
                continue
            except InfraError as e:
                print(f"INFRA ERROR, worker {n} stops: {e}", flush=True)
                return
            res["tier"] = a.tier
            try:
                save_result(os.path.join(OUT, h + ".json"), res)
            except InfraError as e:
                print(f"INFRA ERROR, worker {n} stops: {e}", flush=True)
                return
            with lock:
                print(f"{h[:10]} slot{n} {res['status']:<12} {res.get('case', '')}", flush=True)

    ts = [threading.Thread(target=worker, args=(int(n),)) for n in a.slots.split(",")]
    for t in ts:
        t.start()
    for t in ts:
        t.join()


if __name__ == "__main__":
    main()
