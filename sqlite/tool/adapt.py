#!/usr/bin/env python3
"""Adapted tier: a Claude agent re-expresses a historical fix's bug on the
target release, for candidates whose verbatim reversal does not apply or no
longer makes an oracle case fail.

Per candidate the agent gets a work directory:

  TASK.md        the instructions (below)
  fix.patch      the original fix: message and full diff (tests included)
  oracle.json    the oracle: per test file, the cases that pass on the
                 target; at least one must fail
  tree/          the target release's source; the agent edits only
                 implementation files here
  check.sh       builds testfixture from tree/ and runs the oracle files

and writes RATIONALE.md (each injected hunk -> the fix hunk it reverses) or
GIVEUP.md. The harness never trusts the agent's report: it takes the diff
of tree/ against the base, restricted to implementation files, and runs the
same gate as the verbatim tier. Then the reference anchor: testfixture at
the fix commit with the fix's implementation reversed (the parent's code,
the fix's tests) must fail some oracle case; signature_equivalence is
"exact" when the adapted run fails one of the same cases.

Usage:
  adapt.py run [-j N] [--limit K] [--ids a,b] [--model M]
  adapt.py anchor [-j N]          (reference anchors for adapted results)
"""

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import sqlite_etna as E  # noqa: E402

AGENT_TIMEOUT = int(os.environ.get("ETNA_AGENT_TIMEOUT", "3600"))
TAG = ""          # --tag: separates runs (state, scratch, dataset) per model


def stage():
    return f"adapt-{TAG}" if TAG else "adapt"


def outdir(cid):
    return E.DATASET / (f"adapted-{TAG}" if TAG else "adapted") / cid[:12]


def slot(cid):
    return f"{TAG}-{cid[:12]}" if TAG else cid[:12]


RETRY = {"apply_fails", "oracle_passes", "build_fails", "not_restorable"}

TASK = """\
# Task: reintroduce a historical SQLite bug into SQLite {target}

You are building a benchmark of *realistic* bugs for evaluating testing
tools. Each benchmark entry is a historical SQLite bug, re-injected into the
current release so that tools can be evaluated on it.

`fix.patch` is the upstream commit that fixed the bug ({date}). Its
implementation hunks cannot simply be reversed on {target}: either they no
longer apply (the code has moved or been rewritten since), or reversing them
no longer brings the bug back (other code now also covers the case).

`tree/` is the source of SQLite {target}. Change implementation files in
`tree/` (src/ and ext/, not tests) so that the bug the fix corrected is
present again, **as the fix's author would recognise it**:

1. First understand the bug: read the commit message, the implementation
   hunks, and the test cases the fix added (they are the oracle; see
   `oracle.json`). Then find where that logic lives in {target}.
2. Re-express the pre-fix behaviour in today's code. Prefer the smallest
   change that restores exactly what the fix removed (an omitted check, a
   wrong condition, a missing call, the old computation). Every changed
   line must trace to a hunk of the fix.
3. Do NOT invent a different bug, add unrelated faults, change tests, test
   harness code, build files, or anything outside src/ and ext/ (excluding
   test-only C files). Do not make the change conditional on test names,
   data, or anything that would only trigger in the oracle.
4. If later code covers the same case from another path (the bug was fixed
   twice), you may also revert that other path, but only if it is clearly
   the same defect; name the code in RATIONALE.md.
5. Run `./check.sh` to build and run the oracle. Success means at least one
   oracle case fails (wrong result, error, assert or crash), and ideally the
   failure resembles what the fix's tests guard against. A build takes
   about a minute.

When done, write `RATIONALE.md`: for each hunk you changed, the fix hunk it
reverses and why the code is equivalent; then the oracle cases that fail
and how. If the bug cannot exist in {target} in any recognisable form (the
whole mechanism was removed or redesigned), do not force it: write
`GIVEUP.md` explaining why, and leave `tree/` unchanged.
"""

CHECK = """\
#!/bin/bash
# Build testfixture from tree/ and run the oracle test files. Prints, per
# file, the oracle cases that FAIL (the goal) and the end of the output.
set -u
cd "$(dirname "$0")"
exec python3 {tool}/adapt.py _check "$PWD"
"""

SETTINGS = {
    "sandbox": {"enabled": True, "autoAllowBashIfSandboxed": True, "allowUnsandboxedCommands": False,
                "filesystem": {"allowWrite": ["{work}", "{scratch}", "/tmp"],
                               "denyRead": ["~/.ssh", "~/.aws", "~/.dd-auth", "~/.vault-token", "~/dd",
                                            "~/.config", "~/.gitconfig", "~/.git-credentials"]},
                "network": {"allowedDomains": [], "strictAllowlist": True}},
    "permissions": {"allow": ["Bash", "Read", "Edit", "Write", "Glob", "Grep"],
                    "deny": ["WebFetch", "WebSearch"]},
}


def workdir(cid):
    return E.WORK / "adapt" / slot(cid)


def prepare(c, oracle):
    w = workdir(c["id"])
    if w.exists():
        shutil.rmtree(w)
    w.mkdir(parents=True)
    base_src, _ = E.base_paths()
    shutil.copytree(base_src, w / "tree", symlinks=True)
    tgt = E.target_commit()
    (w / "TASK.md").write_text(TASK.format(target=E.TARGET, date=c["date"][:10]))
    (w / "fix.patch").write_text(E.git("show", "--format=fuller", c["id"]).stdout)
    (w / "oracle.json").write_text(json.dumps(oracle, indent=2) + "\n")
    (w / "check.sh").write_text(CHECK.format(tool=Path(__file__).resolve().parent))
    (w / "check.sh").chmod(0o755)
    s = json.loads(json.dumps(SETTINGS).replace("{work}", str(w)).replace("{scratch}", str(E.WORK)))
    (w / "settings.json").write_text(json.dumps(s, indent=2))
    return w


def agent_check(w):
    """check.sh: build tree/ and run the oracle; for the agent's feedback."""
    w = Path(w)
    oracle = json.load(open(w / "oracle.json"))
    tf, secs, log = E.build_testfixture(w / "tree", w / ".build", jobs=2)
    if not tf:
        print("BUILD FAILED\n" + log[-3000:])
        return 1
    for f, names in oracle.items():
        r = E.run_testfile(tf, w / "tree", f)
        passing = set(r["ok"])
        bad = [n for n in names if n not in passing]
        print(f"== {f}: {len(bad)} of {len(names)} oracle cases failing: {bad[:40] or 'none'}"
              f"{' (incomplete run: crash, assert or timeout)' if not r['complete'] else ''}")
        print(r["tail"][-1200:] if r["tail"] else "")
    shutil.rmtree(w / ".build", ignore_errors=True)
    return 0


def impl_changes(w):
    base_src, _ = E.base_paths()
    r = E.run(["diff", "-rq", str(base_src), str(w / "tree")], check=False)
    files = []
    for line in r.stdout.splitlines():
        m = re.match(r"Files (\S+) and (\S+) differ", line)
        if m:
            f = os.path.relpath(m.group(1), base_src)
            files.append(f)
    impl = [f for f in files if E.IMPL.match(f) and not E.NOT_IMPL.search(f)]
    return impl, sorted(set(files) - set(impl))


def adapt_one(c, oracle, model):
    """One candidate; its work directory is removed whatever the outcome
    (RATIONALE.md, GIVEUP.md and the injection are copied out first)."""
    try:
        return _adapt_one(c, oracle, model)
    finally:
        shutil.rmtree(workdir(c["id"]), ignore_errors=True)


def _adapt_one(c, oracle, model):
    rec = {"id": c["id"], "target": E.target_commit(), "date": c["date"], "subject": c["subject"],
           "oracle": oracle, "model": model}
    if not oracle:
        rec["result"] = "no_oracle"
        return rec
    w = prepare(c, oracle)
    t0 = time.time()
    try:
        r = subprocess.run(
            [os.environ.get("CLAUDE_BIN", os.path.expanduser("~/.local/bin/claude")), "-p", "Read TASK.md and do the task it describes.", "--model", model,
             "--settings", str(w / "settings.json"), "--output-format", "json",
             "--max-turns", "200"],
            cwd=w, capture_output=True, text=True, timeout=AGENT_TIMEOUT)
        out = r.stdout
    except subprocess.TimeoutExpired as e:
        out = (e.stdout or b"").decode() if isinstance(e.stdout, bytes) else (e.stdout or "")
        rec["agent_timeout"] = True
    rec["agent_seconds"] = round(time.time() - t0)
    try:
        meta = json.loads(out)
        rec["agent"] = {k: meta.get(k) for k in ("total_cost_usd", "num_turns", "is_error", "subtype")}
    except (json.JSONDecodeError, TypeError):
        rec["agent"] = {"raw_tail": (out or "")[-500:]}
    d = outdir(c["id"])
    d.mkdir(parents=True, exist_ok=True)
    for f in ("RATIONALE.md", "GIVEUP.md"):
        if (w / f).exists():
            shutil.copy(w / f, d / f)
    if (w / "GIVEUP.md").exists():
        rec["result"] = "gave_up"
        return rec
    impl, other = impl_changes(w)
    rec["files"], rec["non_impl_changes"] = impl, other
    if not impl:
        rec["result"] = "no_change"
        return rec
    if other:
        rec["result"] = "touched_non_impl"     # rejected: tests or build files changed
        return rec
    base_src, _ = E.base_paths()
    text = E.tree_diff(base_src, w / "tree", impl)
    g = E.gate(c["id"], "adapted", text, oracle, 2, files=impl, slot=slot(c["id"]), outdir=d)
    rec["attempt"] = g
    rec["fix_added_failing"] = E.added_by_fix(c, g.get("oracle_failing") or {})
    if g.get("injection_sha256"):
        rec["result"] = "adapted_unanchored"   # anchor stage promotes it
    else:
        rec["result"] = "adapted_not_reproduced"
    shutil.rmtree(w, ignore_errors=True)
    return rec


def cmd_run(a):
    cands = E.candidates()
    v = E.latest("verbatim")
    done = E.latest(stage())
    if a.ids:
        ids = a.ids.split(",")
    else:
        ids = [i for i, r in v.items() if r.get("result") in RETRY and i not in done]
        ids.sort(key=lambda i: cands[i]["date"], reverse=True)
    if a.limit:
        ids = ids[:a.limit]
    print(f"{len(ids)} candidates for the adapted tier", flush=True)
    base_runs = E.latest("base-runs", key="file")
    with ThreadPoolExecutor(a.j) as ex:
        futs = {ex.submit(adapt_one, cands[i], E.oracle_of(cands[i], base_runs), a.model): i for i in ids}
        counts = {}
        for n, fu in enumerate(as_completed(futs), 1):
            i = futs[fu]
            try:
                rec = fu.result()
            except Exception as e:
                rec = {"id": i, "result": "error", "error": str(e)[-1500:]}
            E.append(stage(), rec)
            counts[rec["result"]] = counts.get(rec["result"], 0) + 1
            print(f"  {n}/{len(ids)} {counts}", flush=True)


# --------------------------------------------------------------- anchor

def anchor_one(c, rec):
    """Reference: the fix commit with its implementation hunks reversed (the
    parent's code, the fix's own tests) must fail some oracle case."""
    cid = c["id"]
    tree = E.WORK / "anchor" / slot(cid) / "src"
    try:
        E.export_tree(cid, tree)
        mode, log = E.apply_patch(tree, E.reverse_impl_diff(c))
        if mode != "exact":
            return {"anchor": "reversal_fails"}
        tf, secs, blog = E.build_testfixture(tree, tree.parent / "build", jobs=2)
        if not tf:
            return {"anchor": "build_fails", "build_log": blog[-1500:]}
        ref = {}
        for f, names in rec["oracle"].items():
            if not (tree / f).exists():
                continue
            r = E.run_testfile(tf, tree, f)
            passing = set(r["ok"])
            bad = [n for n in names if n not in passing]
            if bad:
                ref[f] = bad
        adapted = rec["attempt"]["oracle_failing"]
        shared = {f: sorted(set(ref.get(f, [])) & set(n)) for f, n in adapted.items()}
        shared = {f: n for f, n in shared.items() if n}
        return {"anchor": "ok" if ref else "reference_passes", "reference_failing": ref,
                "signature_equivalence": "exact" if shared else ("needs_review" if ref else None),
                "shared_failing": shared}
    finally:
        shutil.rmtree(E.WORK / "anchor" / slot(cid), ignore_errors=True)


def cmd_anchor(a):
    cands = E.candidates()
    todo = [r for r in E.latest(stage()).values()
            if r.get("result") == "adapted_unanchored"]
    with ThreadPoolExecutor(a.j) as ex:
        futs = {ex.submit(anchor_one, cands[r["id"]], r): r for r in todo}
        for fu in as_completed(futs):
            r = futs[fu]
            try:
                an = fu.result()
            except Exception as e:
                an = {"anchor": "error", "error": str(e)[-800:]}
            res = ("confirmed" if an.get("signature_equivalence") == "exact" else
                   "needs_review" if an.get("signature_equivalence") == "needs_review" else "unanchored")
            E.append(stage(), {**r, **an, "result": "adapted_" + res})
            print(f"{res:12} {r['id'][:12]} {r['subject'][:80]}", flush=True)


def main():
    if len(sys.argv) == 3 and sys.argv[1] == "_check":
        sys.exit(agent_check(sys.argv[2]))
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("run")
    p.add_argument("-j", type=int, default=6)
    p.add_argument("--limit", type=int, default=0)
    p.add_argument("--ids", default="")
    p.add_argument("--model", default="claude-opus-5-5")
    p.add_argument("--tag", default="")
    p = sub.add_parser("anchor")
    p.add_argument("-j", type=int, default=8)
    p.add_argument("--tag", default="")
    a = ap.parse_args()
    global TAG
    TAG = a.tag
    {"run": cmd_run, "anchor": cmd_anchor}[a.cmd](a)


if __name__ == "__main__":
    main()
