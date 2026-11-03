#!/usr/bin/env python3
"""Re-verify results recorded while a base build was corrupted.

Agents' build copies were hard links into the shared base build, so an
in-place edit in a build copy changed the base itself (Go: 2026-11-01T11:36Z,
ssa/expand_calls.go; CPython: 2026-10-31T17:52Z, Lib/bdb.py). Results recorded
after that may reflect the corruption. This re-runs them on the restored base
from stored artifacts only (no agents):

  gate   re-run the gate on each stored injection (verbatim or adapted); for
         adapted bugs, recompute the anchor's signature against the stored
         reference results (anchors build the fix commit from scratch, so they
         were not affected)
  repro  re-verify each stored reproducer: clean twice, injected once; update
         its expected output when it still differs, or mark it otherwise

DataFusion (2026-11-03): build slots were synced with rsync -a, which keeps the
commit-time mtimes git archive gives files, so Cargo could reuse a stale build
(another candidate's injection, or a newer revision for anchors). Fixed in
target_datafusion.py; all its gates and anchors are redone (--drop-anchor).

Each re-verified record is appended with "reverified": "<time>" (the latest
record per id wins, as everywhere).

Usage:
  reverify.py gate  --since 2026-11-01T11:36 [-j N] [--stage adapt-sonnet|verbatim]
  reverify.py repro --since 2026-11-01T11:36 [-j N]
"""

import argparse
import importlib
import os
import shutil
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import sqlite_etna as E  # noqa: E402

STAMP = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
GATED = {"adapted_confirmed", "adapted_unanchored", "adapted_needs_review"}


def injection_of(cid, tier):
    p = E.DATASET / ("adapted-sonnet" if tier == "adapted" else "bugs") / cid[:12] / "injection.patch"
    return p.read_text() if p.exists() else None


ANCHOR_KEYS = ("anchor", "build_log", "reference_failing", "shared_failing", "signature_equivalence")


def regate_one(rec, stage, cands, base_runs, drop_anchor=False):
    cid = rec["id"]
    c = cands[cid]
    tier = "adapted" if stage.startswith("adapt") else "verbatim"
    text = injection_of(cid, tier)
    if drop_anchor:                      # the anchors themselves were affected: redo them
        rec = {k: v for k, v in rec.items() if k not in ANCHOR_KEYS}
    new = {**rec, "reverified": STAMP}
    if text is None:
        new["reverify_note"] = "injection patch missing"
        return new
    oracle = E.oracle_of(c, base_runs)
    files = sorted({l[6:].strip() for l in text.splitlines() if l.startswith("+++ b/")})
    g = E.gate(cid, tier, text, oracle, 2, files=files, slot=f"rv-{cid[:12]}",
               outdir=E.WORK / "reverify-out" / cid[:12])
    shutil.rmtree(E.WORK / "reverify-out" / cid[:12], ignore_errors=True)
    new["attempt"] = g
    new["fix_added_failing"] = E.added_by_fix(c, g.get("oracle_failing") or {})
    passed = bool(g.get("injection_sha256"))
    if tier == "verbatim":
        new["result"] = "confirmed" if passed else (
            "build_fails" if g.get("build") == "failed" else "oracle_passes")
        return new
    if not passed:
        new["result"] = "adapted_not_reproduced"
        return new
    ref = rec.get("reference_failing")
    if ref is None:                      # never anchored (e.g. build fails at the fix commit)
        new["result"] = "adapted_unanchored"
        return new
    shared = {f: sorted(set(ref.get(f, [])) & set(n)) for f, n in g["oracle_failing"].items()}
    shared = {f: n for f, n in shared.items() if n}
    new["shared_failing"] = shared
    new["signature_equivalence"] = "exact" if shared else ("needs_review" if ref else None)
    new["result"] = ("adapted_confirmed" if shared else
                     "adapted_needs_review" if ref else "adapted_unanchored")
    return new


def cmd_gate(a):
    cands = E.candidates()
    base_runs = E.latest("base-runs", key="file")
    if a.retry_failed_builds:            # an earlier re-verification whose build failed
        recs = [r for r in E.latest(a.stage).values() if r.get("reverified") and
                (r.get("attempt") or {}).get("build") == "failed"]
    else:
        recs = [r for r in E.latest(a.stage).values() if r.get("at", "") >= a.since and
                (r.get("result") in GATED if a.stage.startswith("adapt") else r.get("result") == "confirmed")]
    print(f"{len(recs)} {a.stage} records from {a.since} to re-gate", flush=True)
    counts = {}
    with ThreadPoolExecutor(a.j) as ex:
        futs = {ex.submit(regate_one, r, a.stage, cands, base_runs, a.drop_anchor): r for r in recs}
        for n, fu in enumerate(as_completed(futs), 1):
            r = futs[fu]
            try:
                new = fu.result()
            except Exception as e:
                new = {**r, "reverified": STAMP, "reverify_error": str(e)[-800:]}
            E.append(a.stage, new)
            key = f"{r['result']} -> {new.get('result')}"
            counts[key] = counts.get(key, 0) + 1
            print(f"  {n}/{len(recs)} {counts}", flush=True)


def reverify_repro_one(rec, R, tier_of):
    cid = rec["id"]
    d = E.DATASET / "repro" / cid[:12]
    new = {**rec, "reverified": STAMP}
    text = injection_of(cid, tier_of(cid))
    if text is None:
        new["reverify_note"] = "injection patch missing"
        return new
    base_src, clean = E.base_paths()
    work = E.WORK / "reverify-repro" / cid[:12]
    try:
        shutil.rmtree(work, ignore_errors=True)
        src = work / "src"
        shutil.copytree(base_src, src, symlinks=True)
        E.run(["chmod", "-R", "u+w", str(src)])
        mode, log = E.apply_patch(src, text)
        if not mode:
            new["result"] = "error"
            new["reverify_note"] = "injection does not apply: " + log[-300:]
            return new
        buggy, secs, blog = E.build_testfixture(src, work / "build", jobs=2)
        if not buggy:
            new["result"] = "error"
            new["reverify_note"] = "build failed: " + blog[-300:]
            return new
        c1, s1 = R.run_repro(clean, d)
        c2, s2 = R.run_repro(clean, d)
        b1, t1 = R.run_repro(buggy, d)
        new["clean_status"], new["buggy_status"] = s1, t1
        if (c1, s1) != (c2, s2):
            new["result"] = "nondeterministic"
        elif (c1, s1) == (b1, t1):
            new["result"] = "no_difference"
        else:
            new["result"] = "confirmed"
            (d / "expected.txt").write_text(c1)
            (d / "buggy-output.txt").write_text(b1)
            (d / "expected-status.txt").write_text(f"{s1}\n")
        return new
    finally:
        shutil.rmtree(work, ignore_errors=True)


def cmd_repro(a):
    kind = os.environ.get("ETNA_KIND", "sqlite")
    R = importlib.import_module({"go": "repro_go", "cpython": "repro_cpython", "valkey": "repro_valkey"}
                                .get(kind, "repro"))
    ver = E.latest("verbatim")
    tier_of = lambda cid: "verbatim" if ver.get(cid, {}).get("result") == "confirmed" else "adapted"
    if a.retry_failed_builds:
        recs = [r for r in E.latest("repro").values() if r.get("reverified") and r.get("result") == "error"
                and r.get("reverify_note", "").startswith("build failed")]
    else:
        recs = [r for r in E.latest("repro").values() if r.get("at", "") >= a.since and r.get("result") == "confirmed"]
    print(f"{len(recs)} reproducers from {a.since} to re-verify", flush=True)
    counts = {}
    with ThreadPoolExecutor(a.j) as ex:
        futs = {ex.submit(reverify_repro_one, r, R, tier_of): r for r in recs}
        for n, fu in enumerate(as_completed(futs), 1):
            r = futs[fu]
            try:
                new = fu.result()
            except Exception as e:
                new = {**r, "reverified": STAMP, "reverify_error": str(e)[-800:]}
            E.append("repro", new)
            counts[new.get("result")] = counts.get(new.get("result"), 0) + 1
            print(f"  {n}/{len(recs)} {counts}", flush=True)


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    for name in ("gate", "repro"):
        p = sub.add_parser(name)
        p.add_argument("--since", required=True)
        p.add_argument("-j", type=int, default=4)
        p.add_argument("--retry-failed-builds", action="store_true",
                       help="redo records whose earlier re-verification failed to build (--since ignored)")
        if name == "gate":
            p.add_argument("--stage", default="adapt-sonnet")
            p.add_argument("--drop-anchor", action="store_true",
                           help="clear stored anchor results (to be recomputed by adapt.py anchor)")
    a = ap.parse_args()
    E.WORK.mkdir(parents=True, exist_ok=True)
    {"gate": cmd_gate, "repro": cmd_repro}[a.cmd](a)


if __name__ == "__main__":
    main()
