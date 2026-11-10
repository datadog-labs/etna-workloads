#!/usr/bin/env python3
"""The unattended full run: verbatim -> adapted (sonnet) -> anchors -> adapted
retries (opus) -> anchors -> reproducers. Every stage is resumable (completed
results are skipped) and stops at its spend cap (caps.json).

Usage: chain.py [--verbatim-pid PID]
"""
import argparse, json, os, sys, time, traceback
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import agentlib, agents, anchor, gate, tstree

W = tstree.WORK
OK_FAIL = ("agent_no_change", "no_failure", "build_failed", "apply_failed", "non_impl_change",
           "reverse_mismatch", "empty_injection")


def log(*a):
    print(time.strftime("%H:%M:%S"), *a, flush=True)


def load(path):
    return json.load(open(path)) if os.path.exists(path) else None


def wait_pid(pid):
    while os.path.exists(f"/proc/{pid}"):
        time.sleep(30)


def run_pool(fn, items, workers, label):
    n = 0
    with ThreadPoolExecutor(workers) as ex:
        futs = [ex.submit(fn, x) for x in items]
        for f in futs:
            try:
                r = f.result()
                n += 1
                log(label, n, len(items), r.get("name") or "", r.get("status"),
                    f"${(r.get('agent') or {}).get('total_cost_usd') or 0:.2f}",
                    f"{label} total ${agentlib.spent(label if label != 'anchor' else '__none__'):.2f}")
            except agentlib.CapReached as e:
                log("CAP", e)
                for g in futs:
                    g.cancel()
                return False
            except Exception:
                log("job error", traceback.format_exc()[-800:])
    return True


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--verbatim-pid", type=int)
    ap.add_argument("--workers", type=int, default=4)
    a = ap.parse_args()
    if a.verbatim_pid:
        log("waiting for verbatim pid", a.verbatim_pid)
        wait_pid(a.verbatim_pid)
    # Re-run any verbatim jobs that ended retryable/error (gate.py skips finished ones).
    os.system(f"cd {os.path.dirname(os.path.abspath(__file__))} && python3 gate.py verbatim {W}/verbatim --workers 6")

    cands = sorted(map(json.loads, open(f"{W}/candidates.jsonl")), key=lambda c: -c["time"])
    tri = {json.loads(l)["sha"]: json.loads(l) for l in open(f"{W}/triage.jsonl")}
    units = json.load(open(f"{W}/units_all.json"))
    base_pass = gate.load_base()

    def vstatus(c):
        r = load(f"{W}/verbatim/{c['sha'][:12]}/result.json")
        return r["status"] if r else "conflict"

    pool = [c for c in cands if tri.get(c["sha"], {}).get("label") == "bug" and c["time"] >= agents.HEREBY_ERA
            and units.get(c["sha"]) and vstatus(c) != "gate_pass"]
    log("adapted pool", len(pool))
    run_pool(lambda c: agents.adapted_job(c, units[c["sha"]], base_pass, "sonnet", 3.0, "adapted"),
             pool, a.workers, "adapted")

    cmap = {c["sha"]: c for c in cands}

    def do_anchor(stage):
        dirs = []
        for c in pool:
            d = f"{W}/{stage}/{c['sha'][:12]}"
            r = load(f"{d}/result.json")
            if r and r["status"] == "gate_pass" and not os.path.exists(f"{d}/anchor.json"):
                dirs.append(d)
        log(stage, "anchors to run", len(dirs))
        run_pool(lambda d: dict(name=os.path.basename(d), **anchor.anchor(d, cmap)), dirs, 3, "anchor")

    do_anchor("adapted")

    retry = []
    for c in pool:
        r = load(f"{W}/adapted/{c['sha'][:12]}/result.json")
        if r and r["status"] in OK_FAIL and tri[c["sha"]]["confidence"] >= 0.8:
            retry.append(c)
    log("opus retry pool", len(retry))
    run_pool(lambda c: agents.adapted_job(c, units[c["sha"]], base_pass, "opus", 4.0, "adapted-retry"),
             retry, 3, "adapted-retry")
    do_anchor("adapted-retry")

    # Reproducers: strict bugs first, then the remaining gate passes; newest first within each.
    bugs = []
    for c in cands:
        s12 = c["sha"][:12]
        t = tri.get(c["sha"], {})
        for stage in ("verbatim", "adapted", "adapted-retry"):
            d = f"{W}/{stage}/{s12}"
            r = load(f"{d}/result.json")
            if not r or r["status"] != "gate_pass":
                continue
            an = load(f"{d}/anchor.json")
            strict = bool(r.get("failing_added")) and t.get("label") == "bug" and \
                (stage == "verbatim" or (an or {}).get("status") == "exact")
            bugs.append((not strict, -c["time"], d, c["subject"]))
            break
    bugs.sort()
    log("reproducer pool", len(bugs), "strict", sum(1 for b in bugs if not b[0]))
    run_pool(lambda b: dict(name=os.path.basename(b[2]), **agents.repro_job(b[2], b[3], "sonnet", 1.5)),
             bugs, a.workers, "repro")
    log("chain done; spend", {s: round(agentlib.spent(s), 2) for s in ("triage", "adapted", "adapted-retry", "repro")})


if __name__ == "__main__":
    main()
