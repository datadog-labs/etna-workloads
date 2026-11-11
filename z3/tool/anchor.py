#!/usr/bin/env python3
"""Anchor adapted bugs: at the fix commit F, build F (fix present) and F with its implementation
hunks reversed (parent's code + fix's tests); the anchor is 'exact' when some unit that the adapted
injection fails also fails (both runs) on reversed-F while passing (both runs) on F.
Uses one persistent anchor slot, content-synced (rsync -rlpc) so incremental builds stay correct.
Usage: anchor.py [--only sha,..]   -> data/anchor/<sha>.json"""
import os, sys, json, argparse, subprocess, shutil, time, re, fcntl
sys.path.insert(0, os.path.dirname(__file__))
from gate import *

OUT = os.path.join(DATA, "anchor")
CMAKE_PATCHED = False
COMPAT = False
ANCHOR = os.path.join(WORK, "anchor")
ASRC, ABUILD, STAGE = (os.path.join(ANCHOR, x) for x in ("src", "build", "stage"))


def list_units(build):
    out = subprocess.run([os.path.join(build, "test-z3"), "/h"], capture_output=True, text=True,
                         stdin=subprocess.DEVNULL).stdout
    on, us = False, set()
    for l in out.splitlines():
        if l.startswith("Module names"): on = True; continue
        if on and l.startswith("    "): us.add(l.strip().replace("(...)", ""))
    return us


def build_rev(sha, log):
    shutil.rmtree(STAGE, ignore_errors=True)
    os.makedirs(STAGE)
    subprocess.run(f"git -C {REPO} archive {sha} | tar -x -C {STAGE}", shell=True, check=True)
    # old/new revisions may demand a newer CMake than the host's 3.28: lower the minimum (anchor builds only)
    global CMAKE_PATCHED
    CMAKE_PATCHED = False
    cml = os.path.join(STAGE, "CMakeLists.txt")
    bs = os.path.join(STAGE, "contrib", "cmake", "bootstrap.py")
    if os.path.exists(cml) and not os.path.exists(os.path.join(STAGE, "src", "CMakeLists.txt")) and os.path.exists(bs):
        # 2016-2017 revisions keep their CMake files in contrib/cmake and need Z3's own bootstrap step
        subprocess.run(["python3", bs, "create"], cwd=STAGE, capture_output=True)
    if not os.path.exists(cml):
        shutil.rmtree(STAGE, ignore_errors=True)
        return "no_cmake"   # pre-2016 revision: built with scripts/mk_make.py only
    txt = open(cml).read()
    m = re.search(r"cmake_minimum_required\s*\(\s*VERSION\s+(\d+)\.(\d+)", txt)
    if m and (int(m.group(1)), int(m.group(2))) > (3, 28):
        open(cml, "w").write(txt[:m.start()] + "cmake_minimum_required(VERSION 3.28" + txt[m.end():])
        CMAKE_PATCHED = True
    sync_src(STAGE, ASRC)
    shutil.rmtree(STAGE, ignore_errors=True)
    if not os.path.exists(os.path.join(ABUILD, "build.ninja")):
        if not configure(ASRC, ABUILD, log):
            return "configure_fail"
    global COMPAT
    COMPAT = False
    st, _ = ninja(ABUILD, log, jobs=8)
    if st == "fail" and re.search(r"'u?int(ptr|8|16|32|64)_t' (does not name a type|was not declared)",
                                  open(log, errors="replace").read()[-400000:]):
        # old revision vs GCC 13: <cstdint> is no longer included transitively -> compiler-compat flag
        shutil.rmtree(ABUILD, ignore_errors=True)
        if not configure(ASRC, ABUILD, log, extra=("-DCMAKE_CXX_FLAGS=-include cstdint",)):
            return "configure_fail"
        COMPAT = True
        st, _ = ninja(ABUILD, log, jobs=8)
    if st == "fail" and not COMPAT:  # maybe stale configuration from a distant revision: reconfigure from scratch once
        shutil.rmtree(ABUILD, ignore_errors=True)
        if not configure(ASRC, ABUILD, log):
            return "configure_fail"
        st, _ = ninja(ABUILD, log, jobs=8)
    return st


def run_set(units):
    res = {}
    for u in units:
        res[u] = [run_case(ABUILD, u, 1200 if not u.startswith("z3test:") else 120) for _ in range(2)]
        res[u] = [{k: r[k] for k in ("status", "detail", "secs")} for r in res[u]]
    return res


def anchor_one(sha, impl, failing, log):
    rec = dict(sha=sha, adapted_failing=failing)
    st = build_rev(sha, log)
    rec["build_fix"] = st
    rec["cmake_min_lowered_to_3_28"] = CMAKE_PATCHED
    cache = os.path.join(ABUILD, "CMakeCache.txt")
    rec["compat_distutils_shim"] = True
    rec["compat_include_cstdint"] = os.path.exists(cache) and "-include cstdint" in open(cache, errors="replace").read()
    if st != "ok":
        rec["anchor"] = "build_fails" if st != "error" else "retry"
        if st == "no_cmake":
            rec["build_fails_reason"] = "pre-CMake revision (mk_make.py build not supported by this tooling)"
        return rec
    have = list_units(ABUILD)
    units = [u for u in failing if u.startswith("z3test:") or u in have]
    rec["units_present"] = units
    if not units:
        rec["anchor"] = "units_missing"
        return rec
    rec["at_fix"] = run_set(units)
    ok_at_fix = [u for u, rs in rec["at_fix"].items() if all(r["status"] == "pass" for r in rs)]
    patch = impl_diff(sha, impl)
    r = subprocess.run(["git", "apply", "-R"], cwd=ASRC, input=patch, text=True, capture_output=True)
    if r.returncode != 0:
        rec["anchor"] = "reverse_fails_at_fix"
        return rec
    st = build_rev_inplace(log)
    rec["build_reversed"] = st
    if st != "ok":
        rec["anchor"] = "build_fails" if st != "error" else "retry"
        return rec
    rec["at_reversed"] = run_set(ok_at_fix)
    fails = sorted(u for u, rs in rec["at_reversed"].items() if all(x["status"] == "fail" for x in rs))
    rec["reversed_failing"] = fails
    rec["anchor"] = "exact" if fails else "none"
    return rec


def build_rev_inplace(log):
    st, _ = ninja(ABUILD, log, jobs=8)
    return st


def toolchain_failure(log):
    """Did an earlier anchor build fail for host-toolchain reasons (fixed by the compat measures)?"""
    try:
        t = open(log, errors="replace").read()
    except OSError:
        return False
    return bool(re.search(r"No module named 'distutils'|'u?int(ptr|8|16|32|64)_t' (does not name a type|was not declared)", t))


COMPAT_PY = os.path.join(os.path.dirname(os.path.abspath(__file__)), "compat")


def main():
    # old revisions' generator scripts import distutils (removed in Python 3.12): provide a local shim
    os.environ["PYTHONPATH"] = COMPAT_PY + (os.pathsep + os.environ["PYTHONPATH"] if os.environ.get("PYTHONPATH") else "")
    ap = argparse.ArgumentParser()
    ap.add_argument("--only", default="")
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    os.makedirs(ANCHOR, exist_ok=True)
    lockf = open(os.path.join(ANCHOR, ".lock"), "w")
    fcntl.flock(lockf, fcntl.LOCK_EX)   # one anchor process at a time (shared anchor tree)
    logdir = os.path.join(WORK, "logs", "anchor"); os.makedirs(logdir, exist_ok=True)
    cands = {c["sha"]: c for f in ("candidates.json", "candidates_z3test.json")
             for c in json.load(open(os.path.join(DATA, f)))}
    adir = os.path.join(DATA, "adapted")
    todo = []
    for f in sorted(os.listdir(adir)):
        r = json.load(open(os.path.join(adir, f)))
        if r.get("status") != "pass_gate":
            continue
        if a.only and not any(r["sha"].startswith(x) for x in a.only.split(",")):
            continue
        of = os.path.join(OUT, r["sha"] + ".json")
        if os.path.exists(of):
            prev = json.load(open(of))
            if prev["anchor"] != "retry" and not (prev["anchor"] == "build_fails" and prev.get("build_fix") == "configure_fail") \
                    and not (prev["anchor"] == "build_fails" and "compat_distutils_shim" not in prev
                             and toolchain_failure(os.path.join(logdir, r["sha"][:12] + ".log"))):
                continue
        todo.append(r)
    # order by commit time so consecutive anchors are close revisions (cheap incremental builds)
    todo.sort(key=lambda r: -cands[r["sha"]]["time"])
    print(len(todo), "anchors to do", flush=True)
    for r in todo:
        c = cands[r["sha"]]
        t0 = time.time()
        try:
            rec = anchor_one(r["sha"], c["impl"], r["failing"], os.path.join(logdir, r["sha"][:12] + ".log"))
        except Exception as e:
            rec = dict(sha=r["sha"], anchor="retry", error=repr(e))
        rec["secs"] = round(time.time() - t0)
        json.dump(rec, open(os.path.join(OUT, r["sha"] + ".json"), "w"), indent=1)
        print(r["sha"][:10], rec["anchor"], rec.get("reversed_failing"), rec["secs"], flush=True)


if __name__ == "__main__":
    main()
