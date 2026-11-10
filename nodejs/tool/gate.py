#!/usr/bin/env python3
"""Verbatim gate: reverse each candidate's implementation diff on the release and test it.

For each candidate (newest first), in a worker slot:
  1. oracle  = the fix's test cases (as present in the release) passing in both base runs
  2. inject  = reverse of the fix's implementation hunks (git apply, else patch -F2)
  3. store   = injection.patch (pristine -> slot diff, implementation files only)
  4. build   = incremental make in the slot (+ cctest if C++ oracle cases)
  5. test    = oracle cases twice; failing = failed (fail/crash/timeout) in both runs
  6. revert  = reverse the *stored* patch; every touched file must equal pristine
Gate passes if apply ok, build ok, >=1 oracle case fails twice, revert is exact.

Resumable: results are appended to --out; finished shas are skipped.
"""
import argparse, json, os, queue, shutil, subprocess, sys, threading, time, traceback
import nodetest, slot as S

REPO = os.path.expanduser("~/node-etna-work/node")
BUILD_LOCK = threading.Semaphore(1)  # one make -j16 at a time across slots
STOP_FILE = os.path.expanduser("~/node-etna-work/STOP")  # touch to stop between candidates
FAST = False  # --fast: lib-only candidates in --node-builtin-modules-path slots, no build


def impl_diff(c):
    return subprocess.run(["git", "-C", REPO, "diff", "--binary", f"{c['sha']}^", c["sha"], "--",
                           *c["impl_files"]], capture_output=True, check=True).stdout


def added_cases(c, cases):
    """Cases the fix itself added: test files created by the fix, or gtest TESTs it added."""
    st = subprocess.run(["git", "-C", REPO, "show", "--format=", "--name-status", "--no-renames",
                         c["sha"], "--", "test/"], capture_output=True, text=True).stdout
    added_files = {l.split("\t")[1] for l in st.splitlines() if l.startswith("A\t")}
    out = []
    for case in cases:
        if case.startswith("cctest:"):
            name = case[len("cctest:"):]
            suite, test = name.split(".", 1)
            d = subprocess.run(["git", "-C", REPO, "show", "--format=", c["sha"], "--", "test/cctest/"],
                               capture_output=True, text=True, errors="replace").stdout
            import re
            if re.search(rf"^\+\s*TEST(?:_F)?\(\s*{suite}\s*,\s*{test}\s*\)", d, re.M):
                out.append(case)
        else:
            if any(f.startswith(f"test/{case}.") for f in added_files):
                out.append(case)
    return out


def expand_units(units, base):
    """Unit (test file) -> the cases the base run reported for it (wpt reports sub-cases)."""
    out = []
    for u in units:
        sub = sorted(k for k in base if k.startswith(u + "/"))
        out += sub if sub else [u]
    return out


def unit_of(case):
    """Case -> the test.py unit to run it (wpt sub-cases run via their file)."""
    if case.startswith("wpt/"):
        return "/".join(case.split("/")[:2])
    return case


def run_twice(tree, js, cc, scratch):
    runs = []
    units = sorted({unit_of(c) for c in js})
    for _ in range(2):
        r, _ = nodetest.run_js(tree, os.path.join(tree, "out/Release/node"), units, jobs=4,
                               scratch=scratch)
        rc, _ = nodetest.run_cctest(tree, cc)
        runs.append({**r, **rc})
    return runs


def gate_one(c, slotdir, base, workroot, injection=None, tier="verbatim"):
    """Gate one candidate.  injection=None: reverse of the fix's implementation diff
    (verbatim tier).  Otherwise `injection` (bytes, unified diff against the release,
    e.g. written by an adapted agent) is applied forward exactly, without fuzz."""
    S.require_pristine(slotdir)
    res = {"sha": c["sha"], "tier": tier, "t0": time.time()}
    cases = expand_units(c["js_units"], base) + c["cc_units"]
    oracle = [u for u in cases if base.get(u) == ["pass", "pass"]]
    res["oracle"] = oracle
    res["oracle_dropped"] = {u: base.get(u) for u in cases if u not in oracle}
    if not oracle:
        res["status"] = "no-oracle"
        return res
    if injection is None:
        d = impl_diff(c)
        files = [f for f in S.patch_files(d.decode(errors="replace")) if S.is_impl(f)]
        how = S.apply(slotdir, d, reverse=True)
    else:
        files = S.patch_files(injection.decode(errors="replace"))
        if not files or not all(S.is_impl(f) for f in files):
            res["status"] = "injection-not-impl-only"
            res["files"] = files
            return res
        how = S.apply(slotdir, injection, fuzz=False)
    if not how:
        S.restore(slotdir, files)
        res["status"] = "apply-fail"
        return res
    res["apply"] = how
    work = os.path.join(workroot, c["sha"][:12])
    os.makedirs(work, exist_ok=True)
    try:
        patch = S.make_patch(slotdir, files)
        res["injection"] = patch.decode(errors="replace")
        touched = S.patch_files(res["injection"])
        assert all(S.is_impl(f) for f in touched), touched
        if not patch.strip():
            res["status"] = "empty-injection"
            return res
        js = [u for u in oracle if not u.startswith("cctest:")]
        cc = [u for u in oracle if u.startswith("cctest:")]
        t = time.time()
        if FAST:
            # Fast-path slot: lib/*.js is read from disk at run time; no rebuild needed.
            assert all(f.startswith("lib/") for f in touched), touched
            ok = True
        else:
            with BUILD_LOCK:
                ok = S.build(slotdir, cctest=bool(cc), log=os.path.join(work, "build.log"))
        res["build_s"] = round(time.time() - t, 1)
        if not ok:
            res["status"] = "build-fail"
            res["build_log_tail"] = open(os.path.join(work, "build.log"), errors="replace").read()[-3000:]
        else:
            runs = run_twice(slotdir, js, cc, work)
            res["inj_runs"] = runs
            failing = [u for u in oracle
                       if all(r.get(u) in ("fail", "crash", "timeout") for r in runs)]
            res["failing"] = failing
            res["flaky_inj"] = [u for u in oracle if u not in failing and
                                any(r.get(u) in ("fail", "crash", "timeout") for r in runs)]
            res["added_failing"] = added_cases(c, failing)
            res["status"] = "pass" if failing else "no-fail"
    finally:
        # Revert with the stored patch; it must restore pristine bytes exactly.
        p = res.get("injection", "").encode()
        if p.strip():
            r = subprocess.run(["patch", "-p1", "-R", "-s", "--no-backup-if-mismatch"], cwd=slotdir,
                               input=p, capture_output=True)
            res["revert_ok"] = r.returncode == 0
        bad = S.matches_pristine(slotdir, files)
        if bad:
            res["revert_ok"] = False
            res["revert_bad"] = bad
            S.restore(slotdir, files)
        elif "revert_ok" not in res:
            res["revert_ok"] = True
        if res.get("status") == "pass" and not res["revert_ok"]:
            res["status"] = "revert-fail"
        shutil.rmtree(work, ignore_errors=True)
    res["secs"] = round(time.time() - res.pop("t0"), 1)
    return res


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--inp", required=True)
    ap.add_argument("--base", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--slots", required=True, help="comma-separated slot dirs")
    ap.add_argument("--only", help="file with shas to run (one per line)")
    ap.add_argument("--limit", type=int)
    ap.add_argument("--apply", default="clean,fuzzy", help="probe apply classes to include")
    ap.add_argument("--fast", action="store_true")
    a = ap.parse_args()
    global FAST
    FAST = a.fast
    base = json.load(open(a.base))["runs"]
    done = set()
    if os.path.exists(a.out):
        done = {json.loads(l)["sha"] for l in open(a.out)}
    cands = [json.loads(l) for l in open(a.inp)]
    if a.only:
        want = set(open(a.only).read().split())
        cands = [c for c in cands if c["sha"] in want]
    cands = [c for c in cands if c["apply"] in a.apply.split(",") and c["sha"] not in done]
    if a.fast:
        cands = [c for c in cands if all(f.startswith("lib/") for f in c["impl_files"])]
    cands.sort(key=lambda c: c["date"], reverse=True)  # newest first
    if a.limit:
        cands = cands[:a.limit]
    q = queue.Queue()
    for c in cands:
        q.put(c)
    lock = threading.Lock()
    workroot = os.path.expanduser("~/node-etna-work/gatework")

    def worker(slotdir):
        while True:
            if os.path.exists(STOP_FILE):
                print("STOP file present; stopping cleanly", flush=True)
                return
            try:
                c = q.get_nowait()
            except queue.Empty:
                return
            try:
                r = gate_one(c, slotdir, base, workroot)
            except Exception:
                r = {"sha": c["sha"], "status": "error", "error": traceback.format_exc()[-2000:]}
                bad = S.matches_pristine(slotdir, c["impl_files"])
                if bad:
                    S.restore(slotdir, c["impl_files"])
            r["slot"] = os.path.basename(slotdir)
            with lock:
                with open(a.out, "a") as f:
                    f.write(json.dumps(r) + "\n")
                print(f"{c['sha'][:10]} {r['status']:12} fail={len(r.get('failing', []))} "
                      f"added={len(r.get('added_failing', []))} {r.get('secs')}s {c['subject'][:60]}",
                      flush=True)

    ts = [threading.Thread(target=worker, args=(s,)) for s in a.slots.split(",")]
    for t in ts:
        t.start()
    for t in ts:
        t.join()


if __name__ == "__main__":
    main()
