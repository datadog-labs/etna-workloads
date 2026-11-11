#!/usr/bin/env python3
"""Triage every candidate with a cheap model. -> data/triage/<sha>.json
Usage: triage.py [--pool inrepo|z3test|all] [--workers 6] [--cap-usd 15]"""
import os, sys, json, subprocess, argparse, concurrent.futures as cf, threading, time, re
sys.path.insert(0, os.path.dirname(__file__))
from common import *

OUT = os.path.join(DATA, "triage")
MODEL = "claude-haiku-5-5"
PROMPT = """You are triaging a commit from the Z3 SMT solver for a dataset of real bugs.
Classify what the commit's implementation change does. Answer ONLY with one JSON object:
{{"label": "bug" | "feature" | "performance" | "refactor" | "test-build-doc",
  "symptom": "soundness" | "crash" | "assertion" | "wrong-model" | "incompleteness" | "nontermination" | "resource" | "api-misbehaviour" | "other" | "none",
  "subsystem": "<short name, e.g. smt/arith, sat, seq, nlsat, rewriter, opt, spacer, api, parser, lp, bv, fpa, datatype, ...>",
  "confidence": <0.0-1.0>,
  "reason": "<one sentence>"}}
"bug" means the change corrects behaviour that was wrong (wrong sat/unsat, crash, assertion
violation, wrong model, wrong result, hang); a fix of a bug only in a test, build or docs is
"test-build-doc"; adding new capability is "feature" even if the message says "fix".

Subject: {subject}
Message:
{body}

Diff (implementation and tests, truncated):
{diff}
"""


def cred_ok():
    r = subprocess.run(os.environ.get("ETNA_CRED_CHECK", "true"), shell=True)
    return r.returncode == 0


def triage_one(c):
    diff = git("show", "--no-color", "--format=", c["sha"], "--", "src")[:12000]
    prompt = PROMPT.format(subject=c["subject"], body=c["body"][:1500], diff=diff)
    for attempt in range(4):
        while not cred_ok():
            time.sleep(60)
        r = subprocess.run(["claude", "-p", "--model", MODEL, "--output-format", "json",
                            "--max-turns", "1", "--tools", ""], input=prompt,
                           capture_output=True, text=True, cwd=os.path.join(WORK, "runs"), timeout=300)
        try:
            d = json.loads(r.stdout)
        except Exception:
            time.sleep(30); continue
        if d.get("is_error"):
            time.sleep(30); continue
        m = re.search(r"\{.*\}", d.get("result", ""), re.S)
        if not m:
            continue
        try:
            t = json.loads(m.group(0))
        except Exception:
            continue
        t["cost_usd"] = d.get("total_cost_usd", 0)
        t["sha"] = c["sha"]
        return t
    return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pool", default="all")
    ap.add_argument("--workers", type=int, default=6)
    ap.add_argument("--cap-usd", type=float, default=15)
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    os.makedirs(os.path.join(WORK, "runs"), exist_ok=True)
    cands = []
    if a.pool in ("inrepo", "all"):
        cands += json.load(open(os.path.join(DATA, "candidates.json")))
    if a.pool in ("z3test", "all"):
        cands += json.load(open(os.path.join(DATA, "candidates_z3test.json")))
    spent = sum(json.load(open(os.path.join(OUT, f))).get("cost_usd", 0) for f in os.listdir(OUT))
    todo = [c for c in cands if not os.path.exists(os.path.join(OUT, c["sha"] + ".json"))]
    print(f"{len(todo)} to triage, spent so far ${spent:.2f}", flush=True)
    lock = threading.Lock()
    def job(c):
        nonlocal spent
        with lock:
            if spent >= a.cap_usd:
                return
        t = triage_one(c)
        if t:
            json.dump(t, open(os.path.join(OUT, c["sha"] + ".json"), "w"), indent=1)
            with lock:
                spent += t["cost_usd"]
            print(c["sha"][:10], t.get("label"), t.get("symptom"), t.get("subsystem"), flush=True)
    with cf.ThreadPoolExecutor(a.workers) as ex:
        list(ex.map(job, todo))
    print(f"spent ${spent:.2f}")


if __name__ == "__main__":
    main()
