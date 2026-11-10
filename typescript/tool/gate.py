#!/usr/bin/env python3
"""The gate: apply an injection to a private copy of the base, build, and run
the candidate's oracle units twice.

Gate holds iff: the injection applies; the tree builds; >=1 oracle case fails
in both injected runs; reversing the stored injection restores the base.

Usage (verbatim stage): gate.py verbatim OUTDIR [--limit N] [--workers W] [--sha S ...]
"""
import argparse, json, os, re, subprocess, sys, time, traceback
from concurrent.futures import ThreadPoolExecutor, as_completed

sys.path.insert(0, os.path.dirname(__file__))
import inject, tstree
from units import norm_title

W = tstree.WORK
REPO = os.path.join(W, "ts")
RETRYABLE = re.compile(rb"ENOSPC|No space left on device|EDQUOT")


def load_base():
    a = json.load(open(f"{W}/baseruns/A/results.json"))["results"]
    b = json.load(open(f"{W}/baseruns/B/results.json"))["results"]
    passing = {t for t, s in a.items() if s == "pass" and b.get(t) == "pass" and not t.startswith("suite:")}
    return passing


def oracle_for(units, base_pass):
    out = {}
    for u in units:
        rx = re.compile(u["grep"])
        for t in base_pass:
            if rx.search(t):
                out.setdefault(t, {"runner": u["runner"], "grep": u["grep"], "added": False})
                out[t]["added"] |= u["added"] or any(k.lower() in norm_title(t) for k in u.get("added_keys", []))
    return out


def run_twice(tree, units, odir, tag):
    res = []
    for k in (1, 2):
        j = f"{odir}/{tag}-run{k}.jsonl"
        if os.path.exists(j):
            os.unlink(j)
        st = tstree.run_units(tree, [(u["runner"], u["grep"]) for u in units], j, f"{odir}/{tag}-run{k}.log",
                              timeout=2400)
        r, m = tstree.parse(j)
        res.append((r, m, st))
    return res


def gate(name, odir, prep, units, base_pass):
    """prep(tree) -> (ok, info). Writes odir/result.json and injection.patch."""
    os.makedirs(odir, exist_ok=True)
    tree = os.path.join(W, "trees", name)
    tstree.rm_tree(tree)
    t0 = time.time()
    result = {"name": name, "status": None}
    try:
        tstree.mk_tree(tree)
        ok, info = prep(tree)
        result["apply"] = info
        if not ok:
            result["status"] = "agent_no_change" if info.get("out") == "agent made no change" else "apply_failed"
            return result
        paths = inject.changed_impl_files(tree)
        bad = [p for p in paths if p.startswith(("src/lib/", "src/testRunner/", "src/harness/"))]
        result["files"] = paths
        if not paths:
            result["status"] = "empty_injection"
            return result
        if bad:
            result["status"] = "non_impl_change"
            result["bad_files"] = bad
            return result
        patch = inject.make_patch(tree, paths)
        open(f"{odir}/injection.patch", "wb").write(patch)
        result["reverse_restores"] = inject.reverse_restores_base(tree, patch, paths)
        oracle = oracle_for(units, base_pass)
        result["oracle_n"] = len(oracle)
        json.dump(oracle, open(f"{odir}/oracle.json", "w"), indent=1)
        if not oracle:
            result["status"] = "no_oracle"
            return result
        ok, reason = tstree.build(tree, f"{odir}/build.log")
        if not ok:
            blog = open(f"{odir}/build.log", "rb").read()
            result["status"] = "retryable" if RETRYABLE.search(blog) else "build_failed"
            result["build_killed"] = reason
            return result
        need = {(o["runner"], o["grep"]) for o in oracle.values()}
        runs = run_twice(tree, [u for u in units if (u["runner"], u["grep"]) in need], odir, "inj")
        fails = []
        for t, o in oracle.items():
            if all(tstree.case_status(r, t) == "fail" for r, _, _ in runs):
                fails.append(t)
        flaky = [t for t, o in oracle.items()
                 if len({tstree.case_status(r, t) == "fail" for r, _, _ in runs}) > 1]
        result["failing"] = sorted(fails)
        result["failing_added"] = sorted(t for t in fails if oracle[t]["added"])
        result["inj_flaky"] = sorted(flaky)
        result["incomplete"] = [m["incomplete"] for _, m, _ in runs]
        errs = {}
        for line in open(f"{odir}/inj-run1.jsonl"):
            e = json.loads(line)
            if e.get("ev") == "fail" and e["title"] in fails and len(errs) < 20:
                errs[e["title"]] = e["err"][:1500]
        json.dump(errs, open(f"{odir}/fail_errors.json", "w"), indent=1)
        if fails:
            subprocess.run(["tar", "-czf", f"{odir}/local_baselines.tgz", "-C", tree, "tests/baselines/local"],
                           capture_output=True)
        if not result["reverse_restores"]:
            result["status"] = "reverse_mismatch"
        else:
            result["status"] = "gate_pass" if fails else "no_failure"
        return result
    except Exception:
        result["status"] = "error"
        result["error"] = traceback.format_exc()[-3000:]
        return result
    finally:
        result["seconds"] = round(time.time() - t0)
        json.dump(result, open(f"{odir}/result.json", "w"), indent=1)
        tstree.rm_tree(tree)


def verbatim_prep(sha, impl_files):
    def prep(tree):
        d = subprocess.run(["git", "-C", REPO, "diff", "--no-renames", "--binary", sha, f"{sha}^", "--", *impl_files],
                           check=True, capture_output=True).stdout
        ok, method, out = inject.apply_patch(tree, d, fuzz=True)
        return ok, {"method": method, "out": out.decode(errors="replace")[-2000:]}
    return prep


def run_stage(jobs, workers):
    """jobs: list of (name, odir, prep, units). Stops on repeated identical fast failures."""
    base_pass = load_base()
    recent = []
    done = 0
    with ThreadPoolExecutor(workers) as ex:
        futs = {ex.submit(gate, n, o, p, u, base_pass): n for n, o, p, u in jobs}
        for f in as_completed(futs):
            r = f.result()
            done += 1
            print(f"[{done}/{len(jobs)}] {r['name']} {r['status']} {r.get('seconds')}s "
                  f"fail={len(r.get('failing', []))} added={len(r.get('failing_added', []))}", flush=True)
            sig = (r["status"], (r.get("error") or "")[-200:])
            if r["status"] in ("error", "build_failed") and r["seconds"] < 20:
                recent.append(sig)
                if len(recent) >= 5 and len(set(recent[-5:])) == 1:
                    print("ABORT: 5 identical fast failures, tooling bug?", sig, flush=True)
                    for g in futs:
                        g.cancel()
                    ex.shutdown(cancel_futures=True)
                    return False
            else:
                recent.clear()
    return True


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("stage")
    ap.add_argument("outdir")
    ap.add_argument("--limit", type=int)
    ap.add_argument("--workers", type=int, default=6)
    ap.add_argument("--sha", nargs="*")
    ap.add_argument("--include-conflict", action="store_true")
    a = ap.parse_args()
    cands = [json.loads(l) for l in open(f"{W}/candidates.jsonl")]
    probe = {json.loads(l)["sha"]: json.loads(l)["apply"] for l in open(f"{W}/probe.jsonl")}
    units = json.load(open(f"{W}/units_all.json"))
    cands.sort(key=lambda c: -c["time"])  # newest first
    if a.sha:
        cands = [c for c in cands if any(c["sha"].startswith(s) for s in a.sha)]
    elif not a.include_conflict:
        cands = [c for c in cands if probe[c["sha"]] != "conflict"]
    jobs = []
    for c in cands:
        odir = os.path.join(a.outdir, c["sha"][:12])
        rj = os.path.join(odir, "result.json")
        if os.path.exists(rj) and json.load(open(rj))["status"] not in ("retryable", "error"):
            continue
        if not units.get(c["sha"]):
            continue
        jobs.append((c["sha"][:12], odir, verbatim_prep(c["sha"], c["impl_files"]), units[c["sha"]]))
    if a.limit:
        jobs = jobs[:a.limit]
    print(f"{len(jobs)} jobs", flush=True)
    run_stage(jobs, a.workers)


if __name__ == "__main__":
    main()
