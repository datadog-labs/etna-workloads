#!/usr/bin/env python3
"""Verbatim tier: reverse the fix's implementation hunks on the release, build, test.

usage: verbatim.py [--slots 0,1,2] [--limit N] [--only COMMIT...]
Results: data/verbatim/<commit>.json (+ injection patch for gate passes).
Resumable: candidates with a result file are skipped.
"""
import argparse
import json
import os
import queue
import shutil
import subprocess
import sys
import threading
import time

sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, WORK, InfraError, git, is_impl, save_result  # noqa: E402
import runner  # noqa: E402
import slot as slotmod  # noqa: E402
import oracle  # noqa: E402

OUT = os.path.join(DATA, "verbatim")
CAND = os.path.join(WORK, "cand")

# Cases that must pass on every build; a failure means the build/sysroot is
# broken in general (e.g. std metadata incompatible with an injected compiler).
CONTROLS = ["tests/ui/process/env-null-vars.rs",
            "tests/ui/proc-macro/attr-stmt-expr-rpass.rs",
            "tests/ui/lint/deny-overflowing-literals.rs",
            "tests/ui/borrowck/borrowck-and-init.rs"]


class SlotBroken(Exception):
    pass


def sh(cmd, cwd, **kw):
    return subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, **kw)


def apply_reverse(slot, patch_path):
    """Reverse-apply the fix's implementation diff. Returns how, or None."""
    if sh(["git", "apply", "-R", patch_path], slot).returncode == 0:
        return "clean"
    if sh(["git", "apply", "-R", "-C1", patch_path], slot).returncode == 0:
        return "fuzzy-C1"
    r = sh(["patch", "-R", "-p1", "--dry-run", "-F3", "-f", "-s", "-i", patch_path], slot)
    if r.returncode == 0:
        r = sh(["patch", "-R", "-p1", "-F3", "-f", "-s", "--no-backup-if-mismatch", "-i", patch_path], slot)
        if r.returncode == 0:
            return "fuzzy-patch"
    return None


def run_oracle(slot, files, wd, tag):
    log = os.path.join(wd, f"{tag}.log")
    code, secs, cases, _ = runner.test(slot, files + CONTROLS, log)
    bad = [k for k, v in cases.items() if v in ("failed", "timeout")]
    text = open(log, errors="replace").read() if os.path.exists(log) else ""
    return dict(exit=code, secs=round(secs, 1), cases=cases, tail=text[-3000:],
                excerpts=runner.failure_excerpts(text, bad[:6]))


def CONTROLS_SEEN(r):
    return [k for k in r["cases"] if runner.case_file(k) in CONTROLS]


def controls_ok(res):
    ctl = {k: v for k, v in res["cases"].items() if runner.case_file(k) in CONTROLS}
    return bool(ctl) and all(v in ("ok", "ignored") for v in ctl.values())


def process(c, slot, orc, patch=None, outdir=None, tag=""):
    """Gate one candidate.  patch=None: reverse the fix (verbatim tier);
    otherwise apply the given injection text (adapted tier)."""
    h = c["commit"]
    wd = os.path.join(CAND, h + tag)
    os.makedirs(wd, exist_ok=True)
    res = dict(commit=h, date=c["date"], subject=c["subject"], slot=slot)
    t0 = time.time()
    try:
        cases = orc["cases"]
        res["oracle"] = cases
        if not cases:
            res["status"] = "no_oracle"
            return res
        files = sorted({runner.case_file(k) for k in cases})
        slotmod.reset(slot)
        if slotmod.dirty(slot) or not slotmod.head_ok(slot):
            raise RuntimeError(f"slot {slot} not clean before candidate")
        if patch is None:
            fix = git("diff", "--no-renames", "--full-index", "--binary", f"{h}^", h, "--", *c["impl_files"])
            fp = os.path.join(wd, "fix-impl.patch")
            open(fp, "w").write(fix)
            how = apply_reverse(slot, fp)
        else:
            fp = os.path.join(wd, "given.patch")
            open(fp, "w").write(patch)
            how = "given" if sh(["git", "apply", fp], slot).returncode == 0 else None
        res["apply"] = how
        if not how:
            res["status"] = "apply_failed"
            return res
        inj = sh(["git", "diff", "--full-index", "--", "compiler"], slot).stdout
        changed = [line[6:] for line in inj.splitlines() if line.startswith("+++ b/")]
        changed += [line[6:] for line in inj.splitlines() if line.startswith("--- a/")]
        if not inj.strip():
            res["status"] = "empty_injection"
            return res
        if not all(is_impl(p) for p in set(changed)):
            res["status"] = "non_impl_injection"
            return res
        ip = os.path.join(wd, "injection.patch")
        open(ip, "w").write(inj)
        code, secs = runner.build(slot, os.path.join(wd, "build.log"))
        res["build_secs"] = round(secs, 1)
        if code != 0:
            res["status"] = "build_failed"
            res["build_tail"] = open(os.path.join(wd, "build.log"), errors="replace").read()[-3000:]
            # The clean tree must still build, else the slot itself is broken.
            slotmod.reset(slot)
            code2, _ = runner.build(slot, os.path.join(wd, "build-clean.log"))
            if code2 != 0:
                raise SlotBroken(f"{slot}: clean tree no longer builds")
            return res
        runs = [run_oracle(slot, files, wd, f"inj{i}") for i in (1, 2)]
        if not all(controls_ok(r) for r in runs):
            # Retry with std rebuilt by the injected compiler.
            res["std_rebuilt"] = True
            runner.build_library(slot, os.path.join(wd, "lib.log"))
            runs = [run_oracle(slot, files, wd, f"inj{i}b") for i in (1, 2)]
            res["controls_failed"] = not all(controls_ok(r) for r in runs)
        failing = sorted(k for k in cases if all(r["cases"].get(k) in ("failed", "timeout") for r in runs))
        missing = sorted(k for k in cases if any(k not in r["cases"] for r in runs))
        res["runs"] = [dict(exit=r["exit"], secs=r["secs"],
                            cases={k: r["cases"].get(k) for k in cases + CONTROLS_SEEN(r)}) for r in runs]
        res["excerpts"] = runs[0]["excerpts"]
        if not any(k in runs[0]["cases"] for k in cases):
            res["test_log_tail"] = runs[0].get("tail", "")
        res["failing"] = failing
        res["missing"] = missing
        res["failing_added_by_fix"] = sorted(k for k in failing if orc["added"].get(runner.case_file(k)))
        # Reverse the stored injection: must restore the release byte for byte.
        r = sh(["git", "apply", "-R", ip], slot)
        res["restore_ok"] = r.returncode == 0 and not slotmod.dirty(slot)
        if not res["restore_ok"]:
            res["status"] = "restore_failed"
        elif res.get("controls_failed"):
            res["status"] = "controls_failed"
        else:
            res["status"] = "gate_pass" if failing else "no_failure"
        if res.get("std_rebuilt"):
            slotmod.reset(slot)
            runner.build(slot, os.path.join(wd, "build-back.log"))
            runner.build_library(slot, os.path.join(wd, "lib-back.log"))
            back = run_oracle(slot, [], wd, "health")
            res["slot_health_after"] = controls_ok(back)
            if not controls_ok(back):
                raise SlotBroken(f"{slot}: controls fail after restoring std")
        if res["status"] == "gate_pass":
            d = os.path.join(outdir or OUT, "patches")
            os.makedirs(d, exist_ok=True)
            shutil.copy(ip, os.path.join(d, f"{h}.patch"))
        return res
    except SlotBroken:
        res["status"] = "error"
        res["error"] = "slot broken"
        raise
    except Exception as e:  # noqa: BLE001
        res["status"] = "error"
        res["error"] = repr(e)
        return res
    finally:
        res["secs"] = round(time.time() - t0, 1)
        slotmod.reset(slot)
        shutil.rmtree(wd, ignore_errors=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--slots", default="0,1,2")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--only", nargs="*")
    ap.add_argument("--status", default="clean,fuzzy")
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    cands = {json.loads(line)["commit"]: json.loads(line) for line in open(os.path.join(DATA, "candidates.jsonl"))}
    probe = {json.loads(line)["commit"]: json.loads(line) for line in open(os.path.join(DATA, "probe.jsonl"))}
    orcs = oracle.load()
    todo = [h for h in cands if probe[h]["status"] in a.status.split(",")]
    if a.only:
        todo = [h for h in cands if any(h.startswith(x) for x in a.only)]
    todo.sort(key=lambda h: cands[h]["date"], reverse=True)  # newest first
    todo = [h for h in todo if not os.path.exists(os.path.join(OUT, f"{h}.json"))]
    if a.limit:
        todo = todo[:a.limit]
    print(f"{len(todo)} candidates to run", flush=True)
    q = queue.Queue()
    for h in todo:
        q.put(h)
    lock = threading.Lock()

    def worker(n):
        s = slotmod.path(n)
        while True:
            try:
                h = q.get_nowait()
            except queue.Empty:
                return
            try:
                r = process(cands[h], s, orcs.get(h, dict(cases={}, added={})))
            except SlotBroken as e:
                print(f"SLOT BROKEN, worker {n} stops: {e}", flush=True)
                return
            try:
                save_result(os.path.join(OUT, f"{h}.json"), r)
            except InfraError as e:
                print(f"INFRA ERROR, worker {n} stops: {e}", flush=True)
                return
            with lock:
                print(f"{h[:10]} {r['date'][:10]} slot{n} {r['status']:<14} "
                      f"fail={len(r.get('failing', []))}/{len(r.get('oracle', []))} "
                      f"{r['secs']:.0f}s {r['subject'][:50]}", flush=True)

    ts = [threading.Thread(target=worker, args=(int(n),)) for n in a.slots.split(",")]
    for t in ts:
        t.start()
    for t in ts:
        t.join()


if __name__ == "__main__":
    main()
