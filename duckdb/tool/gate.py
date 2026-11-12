"""Gate an injection in a build slot: apply, build, run oracle twice, reverse, compare with pristine.

Used by the verbatim worker and to re-verify adapted injections.
"""
import json, os, time
import common
from common import sh
import runtests

BUILD_TIMEOUT = 2 * 3600
import threading
BUILD_SLOTS = threading.BoundedSemaphore(int(os.environ.get("ETNA_MAX_BUILDS", "3")))  # bounds concurrent link memory


def build(slot_src, log):
    with BUILD_SLOTS:
        return _build(slot_src, log)


def _build(slot_src, log):
    r = sh(["python3", os.path.join(common.TOOL, "guard.py"), "--timeout", str(BUILD_TIMEOUT), "--rss-mb", "48000",
            "--log", log, "--", os.path.join(common.TOOL, "build.sh"), slot_src, common.RELEASE])
    g = [l for l in r.stderr.decode().splitlines() if l.startswith("GUARD ")]
    guard = json.loads(g[-1][6:]) if g else {"status": "spawn-failed", "rc": -1, "secs": 0}
    txt = open(log, errors="replace").read() if os.path.exists(log) else ""
    if "No space left on device" in txt:
        guard["infra"] = "disk full"
    return guard


def apply_patch(tree, patch, reverse=False, fuzz=False):
    """Apply a patch to tree. Returns 'clean' / 'fuzzy' / None."""
    args = ["git", "-C", tree, "apply"] + (["-R"] if reverse else [])
    if sh(args + ["--check", "-"], input=patch).returncode == 0:
        sh(args + ["-"], input=patch, check=True)
        return "clean"
    if not fuzz:
        return None
    pargs = ["patch", "-d", tree, "-p1", "--batch", "-F2", "--no-backup-if-mismatch", "-s"] + (["-R"] if reverse else [])
    if sh(pargs + ["--dry-run"], input=patch).returncode == 0:
        sh(pargs, input=patch, check=True)
        return "fuzzy"
    return None


def oracle_runs(slot_src, units, runs=2, jobs=6):
    """Run units `runs` times; return list of per-run {unit: outcome}."""
    out = []
    for _ in range(runs):
        r = runtests.run_units(slot_src, units, jobs=jobs)
        out.append({u: list(v) for u, v in r.items()})
    return out


def failing_both(runs):
    units = runs[0].keys()
    return sorted(u for u in units if all(r[u][0] in runtests.FAILING for r in runs))


def gate(slot_src, injection, oracle, logdir, jobs=6, on_injected=None):
    """Injection already applied in slot_src by the caller. Build, test twice, reverse, compare."""
    res = {}
    t0 = time.time()
    b = build(slot_src, os.path.join(logdir, "build.log"))
    res["build"] = b
    res["build_secs"] = b.get("secs")
    if b.get("infra"):
        res["verdict"] = "infra"; return res
    if b["status"] != "exit" or b["rc"] != 0:
        res["verdict"] = "build-fail"
        txt = open(os.path.join(logdir, "build.log"), errors="replace").read()
        errs = [l for l in txt.splitlines() if "error:" in l][:5]
        res["build_errors"] = errs
    else:
        runs = oracle_runs(slot_src, oracle, jobs=jobs)
        res["runs"] = runs
        if any(o == "infra" for r in runs for o, _ in r.values()):
            res["verdict"] = "infra"
        else:
            res["failing"] = failing_both(runs)
            res["verdict"] = "pass" if res["failing"] else "no-fail"
            if res["failing"] and on_injected:
                try:
                    res.update(on_injected(slot_src, res))
                except Exception as e:  # a reproducer problem never changes the gate verdict
                    res["repro_error"] = repr(e)
    # reversal must restore the base byte for byte
    rev = apply_patch(slot_src, injection, reverse=True)
    res["reverse_ok"] = bool(rev) and common.same_tree(slot_src, common.PRISTINE)
    if not res["reverse_ok"] and res["verdict"] == "pass":
        res["verdict"] = "reverse-fail"
    res["secs"] = round(time.time() - t0, 1)
    return res
