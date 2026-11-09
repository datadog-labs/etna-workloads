#!/usr/bin/env python3
"""Triage candidates with a cheap model, in batches, no tools.

Usage: triage.py OUT.jsonl [--model haiku] [--batch 10] [--limit N] [--workers 4]
Resumable: candidates already in OUT.jsonl are skipped.
"""
import argparse, json, os, subprocess, sys, tempfile, threading
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(__file__))
import agentlib, tstree

W = tstree.WORK
REPO = os.path.join(W, "ts")
STAGE = "triage"
LABELS = ["bug", "feature", "performance", "refactor", "test-build-doc"]
SYMPTOMS = ["crash", "hang", "false-error", "missing-error", "wrong-diagnostic-text", "wrong-type",
            "wrong-emit", "wrong-declaration-emit", "wrong-language-service-result", "wrong-module-resolution",
            "wrong-build-or-watch", "other"]
SUBSYSTEMS = ["scanner-parser", "binder", "checker", "emitter-transformers", "declaration-emit",
              "module-resolution", "program-builder-watch", "services-completions", "services-codefix-refactor",
              "services-navigation-references", "services-formatting", "services-other", "tsserver", "other"]

SYSTEM = f"""You classify commits from the TypeScript compiler repository (microsoft/TypeScript).
For each commit you get its subject, message and the implementation diff (possibly truncated).
Decide what the change is:
- bug: fixes incorrect behaviour of the compiler or language service (crash, wrong diagnostics, wrong
  types, wrong emit, wrong editor results). Fixes to wrong behaviour of an existing feature are bugs.
- feature: new behaviour/capability (new syntax, new option, new check, new quick fix or refactor, new
  editor feature, a deliberate language-design change).
- performance: speed/memory only, behaviour intended to be the same.
- refactor: code restructuring/cleanup without intended behaviour change.
- test-build-doc: only tests, build, infrastructure, docs or messages wording.
Also give the symptom of the bug (or "other" if not a bug), the subsystem, and a confidence in [0,1].
Allowed labels: {LABELS}. Symptoms: {SYMPTOMS}. Subsystems: {SUBSYSTEMS}.
Answer only via the structured output: one entry per commit, using the commit ids given."""

SCHEMA = {
    "type": "object",
    "properties": {"items": {"type": "array", "items": {
        "type": "object",
        "properties": {
            "id": {"type": "string"},
            "label": {"enum": LABELS},
            "symptom": {"enum": SYMPTOMS},
            "subsystem": {"enum": SUBSYSTEMS},
            "confidence": {"type": "number"},
            "reason": {"type": "string"},
        },
        "required": ["id", "label", "symptom", "subsystem", "confidence", "reason"]}}},
    "required": ["items"],
}

lock = threading.Lock()


def describe(c, max_diff=6000):
    d = subprocess.run(["git", "-C", REPO, "diff", "--no-renames", "--stat=100", "-p", "--unified=2",
                        f"{c['sha']}^", c["sha"], "--", *c["impl_files"]],
                       capture_output=True).stdout.decode(errors="replace").replace("\r", "")
    if len(d) > max_diff:
        d = d[:max_diff] + "\n... [diff truncated]"
    return (f"### commit {c['sha'][:12]}\nsubject: {c['subject']}\nmessage:\n{c['body'][:1500]}\n"
            f"test files changed: {len(c['test_files'])} ({', '.join(c['test_files'][:5])})\n"
            f"implementation diff:\n{d}\n")


def run_batch(batch, out, model, i):
    agentlib.check_cap(STAGE, reserve=0.10)
    prompt = "Classify these commits.\n\n" + "\n".join(describe(c) for c in batch)
    logd = os.path.join(W, "triage-logs")
    os.makedirs(logd, exist_ok=True)
    log = os.path.join(logd, f"batch-{batch[0]['sha'][:12]}.log")
    if os.path.exists(log):
        os.unlink(log)
    with tempfile.TemporaryDirectory(dir=os.path.join(W, "scratch")) as td:
        data = agentlib.claude(["--model", model, "--system-prompt", SYSTEM, "--tools", "",
                                "--json-schema", json.dumps(SCHEMA), "--max-budget-usd", "0.5",
                                "--no-session-persistence", "--strict-mcp-config", "--setting-sources", "",
                                prompt], td, STAGE, timeout=600, log_path=log,
                               meta={"batch": batch[0]["sha"][:12], "n": len(batch), "budget": 0.5})
    if data.get("retryable"):
        print(f"batch {i}: retryable: {data.get('why') or str(data.get('result'))[:200]}", flush=True)
        return 0
    items = (data.get("structured_output") or {}).get("items") or []
    byid = {c["sha"][:12]: c for c in batch}
    n = 0
    with lock, open(out, "a") as f:
        for it in items:
            c = byid.get(it.get("id", "")[:12])
            if c:
                f.write(json.dumps({"sha": c["sha"], "model": model, **{k: it[k] for k in
                                    ("label", "symptom", "subsystem", "confidence", "reason")}}) + "\n")
                n += 1
    print(f"batch {i}: {n}/{len(batch)} ${data.get('total_cost_usd', 0):.4f} total ${agentlib.spent(STAGE):.2f}",
          flush=True)
    return n


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("out")
    ap.add_argument("--model", default="haiku")
    ap.add_argument("--batch", type=int, default=10)
    ap.add_argument("--limit", type=int)
    ap.add_argument("--workers", type=int, default=4)
    a = ap.parse_args()
    os.makedirs(os.path.join(W, "scratch"), exist_ok=True)
    done = set()
    if os.path.exists(a.out):
        done = {json.loads(l)["sha"] for l in open(a.out)}
    cands = [json.loads(l) for l in open(f"{W}/candidates.jsonl")]
    cands.sort(key=lambda c: -c["time"])
    todo = [c for c in cands if c["sha"] not in done]
    if a.limit:
        todo = todo[:a.limit]
    batches = [todo[i:i + a.batch] for i in range(0, len(todo), a.batch)]
    print(f"{len(todo)} to triage in {len(batches)} batches", flush=True)
    with ThreadPoolExecutor(a.workers) as ex:
        list(ex.map(lambda ib: run_batch(ib[1], a.out, a.model, ib[0]), enumerate(batches)))


if __name__ == "__main__":
    main()
