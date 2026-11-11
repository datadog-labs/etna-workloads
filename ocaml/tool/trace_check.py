"""Traceability check for adapted injections (the adapted-tier rule: every changed hunk must
trace to a hunk of the fix).  A no-tools model judges each gated adapted bug; flagged ones are
then hand-checked.  -> data/trace/<sha>.json   usage: trace_check.py CAP_USD"""
import json, re, sys
from concurrent.futures import ThreadPoolExecutor
from common import *
import llm

OUT = DATA / "trace"
PROMPT = """You audit a benchmark of injected bugs. An upstream bug FIX was made years ago; an agent then
re-introduced ("injected") the bug into today's code. Rule: every hunk of the INJECTION must undo (a
re-expression in today's code of) some hunk of the FIX. Code may have moved or been renamed since; that
is fine. NOT fine: an injection hunk that breaks code the fix never touched or added, or that removes/alters
behaviour beyond what the fix changed.

Answer with ONE JSON object only:
{{"hunks": [{{"injection_hunk": "<its @@ header>", "traces_to": "<fix hunk header or null>", "ok": true|false, "note": "<short>"}}],
  "verdict": "traces" | "partial" | "unrelated",
  "exceeds_fix": true|false,
  "reason": "<one sentence>"}}
"traces" = every injection hunk undoes part of the fix and nothing beyond it.
"partial" = some hunks trace, but at least one hunk changes code beyond what the fix touched.
"unrelated" = the injection does not undo the fix at all (a different bug that happens to fail the same test).

FIX commit {sha} ({date}): {subject}
FIX implementation diff:
{fixdiff}

INJECTION (applied to today's release):
{inj}

Agent's RATIONALE:
{rat}
"""


def check(c, r):
    fixdiff = git("diff", "--no-renames", f"{c['sha']}^", c["sha"], "--", *c["impl_files"])[:14000]
    inj = (DATA / "patches_adapted" / f"{c['sha']}.patch").read_text(errors="replace")[:10000]
    p = PROMPT.format(sha=c["sha"][:10], date=c["date"][:10], subject=c["subject"], fixdiff=fixdiff,
                      inj=inj, rat=(r.get("rationale") or "(none)")[:3000])
    for _ in range(3):
        out, info = llm.run_claude(p, "trace-check", c["sha"], model="sonnet", timeout=600)
        if out is None:
            continue
        m = re.search(r"\{.*\}", out, re.S)
        try:
            d = json.loads(m.group(0))
            d["model"] = "sonnet"
            return d
        except Exception:
            continue
    return None


def main():
    cap = float(sys.argv[1])
    OUT.mkdir(parents=True, exist_ok=True)
    cands = {c["sha"]: c for c in load("candidates.json")}
    todo = []
    for f in (DATA / "adapted").glob("*.json"):
        r = json.loads(f.read_text())
        if r.get("gate") and not r.get("retryable") and not (OUT / f.name).exists():
            todo.append((cands[r["sha"]], r))
    todo.sort(key=lambda t: -t[0]["ts"])
    print(len(todo), "to check", flush=True)

    def one(t):
        c, r = t
        if llm.spent("trace-check") >= cap:
            return
        d = check(c, r)
        if d:
            (OUT / f"{c['sha']}.json").write_text(json.dumps(d, indent=1))
    with ThreadPoolExecutor(6) as ex:
        list(ex.map(one, todo))
    from collections import Counter
    rs = [json.loads(f.read_text()) for f in OUT.glob("*.json")]
    print(Counter(r["verdict"] for r in rs), "exceeds:", sum(r.get("exceeds_fix", False) for r in rs),
          "spent", round(llm.spent("trace-check"), 2))


if __name__ == "__main__":
    main()
