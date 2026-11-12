#!/usr/bin/env python3
"""Anchor check for adapted bugs, at the original fix commit.

For candidate C with oracle cases K (the cases the adapted injection fails on the release):
  1. tree = C's full source (fix code + fix tests), built in a reusable fixed-path anchor slot
     (sources synced by content, so walking newest -> oldest stays incremental);
  2. run K twice: cases that pass both times are usable;
  3. reverse C's src/ hunks (parent's code with C's tests), rebuild, run K twice;
  4. exact = some usable case of K fails in both reversed runs.
Build failures are recorded honestly ("build-fail"), never retried with source edits.
usage: anchor.py SLOT_SRC SHA CASE... --out result.json
"""
import argparse, json, os, shutil, subprocess, tempfile
import common, gate, runtests
from common import sh


def describe(sha):
    # nearest tag only: the version string is baked into every compile command, so a per-commit string
    # (vX-N-gHASH) would force a full rebuild for each anchor instead of an incremental one
    r = sh(["git", "-C", common.UPSTREAM, "describe", "--tags", "--abbrev=0", "--match", "v[0-9]*", sha])
    return r.stdout.decode().strip() or "v0.0.0"


def checkout_into(slot, sha):
    tmp = tempfile.mkdtemp(prefix="anchor-src-", dir=common.WORK + "/scratch")
    try:
        a = subprocess.Popen(["git", "-C", common.UPSTREAM, "archive", sha], stdout=subprocess.PIPE)
        subprocess.run(["tar", "-x", "-C", tmp], stdin=a.stdout, check=True)
        a.wait()
        common.sync_tree(slot, tmp)
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def build_at(slot, ver, log):
    """Build; if the configure step fails (a CMake cache left by a different revision, e.g. a cached
    CMAKE_CXX_STANDARD), wipe the CMake cache and configure once more from scratch."""
    g = _build_at(slot, ver, log)
    txt = open(log, errors="replace").read() if os.path.exists(log) else ""
    if (g["status"] != "exit" or g["rc"] != 0) and "CMake Error" in txt:
        bdir = os.path.join(slot, "build", "relassert")
        for f in ("CMakeCache.txt",):
            try:
                os.remove(os.path.join(bdir, f))
            except OSError:
                pass
        shutil.rmtree(os.path.join(bdir, "CMakeFiles"), ignore_errors=True)
        os.rename(log, log + ".first-attempt")
        g = _build_at(slot, ver, log)
        g["cmake_cache_reset"] = True
    return g


def _build_at(slot, ver, log):
    env = dict(os.environ, JOBS=os.environ.get("ANCHOR_JOBS", "6"))  # anchors are mostly full rebuilds
    r = sh(["python3", os.path.join(common.TOOL, "guard.py"), "--timeout", str(3 * 3600), "--rss-mb", "48000",
            "--log", log, "--", os.path.join(common.TOOL, "build.sh"), slot, ver], env=env)
    g = [l for l in r.stderr.decode().splitlines() if l.startswith("GUARD ")]
    return json.loads(g[-1][6:]) if g else {"status": "spawn-failed", "rc": -1}


def anchor(slot, c, cases, logdir):
    res = {"sha": c["sha"], "cases": cases}
    os.makedirs(logdir, exist_ok=True)
    checkout_into(slot, c["sha"])
    present = [k for k in cases if k.startswith("cpp:") and os.path.exists(os.path.join(slot, k[4:].split("::")[0]))
               or (not k.startswith("cpp:") and os.path.exists(os.path.join(slot, k)))]
    res["present_at_fix"] = present
    if not present:
        res["status"] = "cases-missing-at-fix"; return res
    ver = describe(c["sha"])
    b = build_at(slot, ver, os.path.join(logdir, "anchor-fix-build.log"))
    res["fix_build"] = b
    if b["status"] != "exit" or b["rc"] != 0:
        res["status"] = "build-fail(fix)"; return res
    runs = gate.oracle_runs(slot, present, jobs=6)
    usable = [k for k in present if all(r[k][0] == "pass" for r in runs)]
    res["fix_runs"] = runs; res["usable"] = usable
    if not usable:
        res["status"] = "cases-not-passing-at-fix"; return res
    if not gate.apply_patch(slot, common.impl_diff(c["sha"], c["parent"]), reverse=True):
        res["status"] = "reverse-fail"; return res
    b = build_at(slot, ver, os.path.join(logdir, "anchor-rev-build.log"))
    res["rev_build"] = b
    if b["status"] != "exit" or b["rc"] != 0:
        res["status"] = "build-fail(reversed)"; return res
    runs = gate.oracle_runs(slot, usable, jobs=6)
    res["rev_runs"] = runs
    res["anchor_failing"] = gate.failing_both(runs)
    res["exact"] = bool(res["anchor_failing"])
    res["status"] = "exact" if res["exact"] else "no-fail"
    return res


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("slot"); ap.add_argument("sha"); ap.add_argument("cases", nargs="+"); ap.add_argument("--out", required=True)
    a = ap.parse_args()
    c = [x for x in common.candidates() if x["sha"].startswith(a.sha)][0]
    r = anchor(os.path.abspath(a.slot), c, a.cases, os.path.dirname(os.path.abspath(a.out)))
    common.write_json(a.out, r)
    print(r["status"])
