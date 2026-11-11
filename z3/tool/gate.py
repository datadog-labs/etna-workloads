"""Gate: build an injected slot tree, run oracle units twice, check reversal restores base."""
import os, json, time
from z3lab import *

BASE_UNITS = None


def base_units():
    global BASE_UNITS
    if BASE_UNITS is None:
        BASE_UNITS = json.load(open(os.path.join(DATA, "base_units.json")))
        p = os.path.join(DATA, "base_z3test.json")
        if os.path.exists(p):
            BASE_UNITS.update(json.load(open(p)))
    return BASE_UNITS


def oracle_units(units):
    b = base_units()
    return [u for u in units if u in b and b[u]["stable_pass"]]


def unit_timeout(u):
    b = base_units()[u]
    if u.startswith("z3test:"):
        return 120
    return int(min(1200, max(120, 5 * b["max_secs"])))


def run_oracle(build, units, runs=2):
    """Run each unit `runs` times; returns {unit: [result,...]}. Retryable errors are surfaced."""
    res = {}
    for u in units:
        res[u] = []
        for _ in range(runs):
            r = run_case(build, u, unit_timeout(u))
            res[u].append({k: r[k] for k in ("status", "detail", "secs")} | {"tail": r["tail"][-800:]})
    return res


def failing_both(res):
    return sorted(u for u, rs in res.items() if rs and all(r["status"] == "fail" for r in rs))


def has_error(res):
    return any(r["status"] == "error" for rs in res.values() for r in rs)


def gate_tree(slot, injection_files, units, log, jobs=5):
    """slot tree already contains the injection. Returns gate record (no slot reset)."""
    s, src, build = slot_paths(slot)
    rec = {}
    # new non-source files outside src/ (agent scratch output such as check.out) cannot affect the
    # build (Z3's CMake lists sources explicitly): drop and record them; anything else non-impl is fatal
    junk = [f for f in injection_files if not is_impl(f) and not f.startswith("src/")
            and not os.path.exists(os.path.join(BASE_SRC, f)) and not f.endswith(IMPL_EXT)]
    if junk:
        rec["ignored_junk"] = junk
        for f in junk:
            os.remove(os.path.join(slot_paths(slot)[1], f))
        injection_files = [f for f in injection_files if f not in junk]
    bad = [f for f in injection_files if not is_impl(f)]
    if bad:
        rec.update(status="non_impl_change", files=bad)
        return rec
    injection = tree_diff(BASE_SRC, src, injection_files)
    rec["injection"] = injection
    rec["files"] = injection_files
    if not injection.strip():
        rec["status"] = "empty_injection"
        return rec
    if not reverse_restores_base(src, injection, injection_files):
        rec["status"] = "reverse_mismatch"
        return rec
    st, secs = ninja(build, log, jobs=jobs)
    rec["build"] = st
    rec["build_secs"] = round(secs)
    if st == "error":
        rec["status"] = "retry"
        return rec
    if st != "ok":
        rec["status"] = "build_fail"
        try:
            rec["build_log_tail"] = open(log, errors="replace").read()[-3000:]
        except Exception:
            pass
        return rec
    ou = oracle_units(units)
    rec["oracle"] = ou
    if not ou:
        rec["status"] = "no_oracle"
        return rec
    res = run_oracle(build, ou)
    if has_error(res):
        rec["status"] = "retry"
        rec["results"] = res
        return rec
    fails = failing_both(res)
    rec["results"] = res
    rec["failing"] = fails
    rec["status"] = "pass_gate" if fails else "no_fail"
    return rec
