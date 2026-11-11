"""Triage every candidate with a cheap model. -> data/triage.json"""
import json, re, sys
from concurrent.futures import ThreadPoolExecutor
from common import *
import llm

PROMPT = """You are triaging commits of the OCaml compiler/runtime repository for a bug dataset.
Classify this commit. Answer with ONE JSON object and nothing else:
{{"label": "bug" | "feature" | "performance" | "refactor" | "test-build-doc",
  "symptom": "crash" | "miscompilation" | "wrong-output" | "accepts-invalid" | "rejects-valid" | "wrong-error-message" | "hang" | "memory" | "other",
  "subsystem": short string (e.g. typing, parsing, pattern-matching, codegen, runtime-gc, stdlib, unix, ...),
  "confidence": number between 0 and 1,
  "reason": one short sentence}}
"bug" means the commit fixes incorrect behaviour that existed before it (including wrong error
messages or warnings, crashes, unsoundness). New capabilities are "feature" even if worded as a fix.

Subject: {subject}
Date: {date}
Message:
{body}

Changes-file entries added:
{news}

Files: {files}

Implementation diff (truncated):
{diff}
"""


def build_prompt(c):
    diff = git("diff", "--no-renames", f"{c['sha']}^", c["sha"], "--", *c["impl_files"])[:7000]
    news = git("diff", "-U0", f"{c['sha']}^", c["sha"], "--", "Changes", check=False)
    news = "\n".join(l[1:] for l in news.splitlines() if l.startswith("+") and not l.startswith("+++"))[:1500]
    return PROMPT.format(subject=c["subject"], date=c["date"], body=c["body"][:2500], news=news or "(none)",
                         files=", ".join(c["impl_files"][:20] + c["test_files"][:10]), diff=diff)


def triage_one(c):
    for attempt in range(3):
        out, info = llm.run_claude(build_prompt(c), "triage", c["sha"], model="haiku", timeout=300)
        if out is None:
            continue
        m = re.search(r"\{.*\}", out, re.S)
        if not m:
            continue
        try:
            d = json.loads(m.group(0))
            d["model"] = "haiku"
            return c["sha"], d
        except Exception:
            continue
    return c["sha"], None


def main():
    cap = float(sys.argv[1]) if len(sys.argv) > 1 else 15.0
    tri = load("triage.json", {})
    cands = sorted(load("candidates.json"), key=lambda c: -c["ts"])
    todo = [c for c in cands if c["sha"] not in tri]
    print(len(todo), "to triage", flush=True)
    with ThreadPoolExecutor(8) as ex:
        futs = []
        for c in todo:
            futs.append(ex.submit(lambda c=c: triage_one(c) if llm.spent("triage") < cap else (c["sha"], None)))
        for i, f in enumerate(futs):
            sha, d = f.result()
            if d:
                tri[sha] = d
            if i % 50 == 0:
                save("triage.json", tri)
                print(i, "spent", round(llm.spent("triage"), 3), flush=True)
    save("triage.json", tri)
    from collections import Counter
    print(Counter(v["label"] for v in tri.values()), "spent", llm.spent("triage"))


if __name__ == "__main__":
    main()
