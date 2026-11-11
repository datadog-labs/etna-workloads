"""Verbatim stage: reverse-apply each candidate's implementation hunks and gate it.

usage: verbatim.py [--limit N] [--slots K] [--only sha,...]
Results: data/verbatim/<sha>.json, injection in data/patches/<sha>.patch.
Newest candidates first; resumable (skips existing results).
"""
import argparse, json, queue, threading, time, traceback
from common import *
from slots import Slot
import gate as G

OUT = DATA / "verbatim"


def added_tests(sha):
    out = git("diff", "--name-status", "--no-renames", f"{sha}^", sha, "--", "testsuite")
    return [l.split("\t")[1][len("testsuite/"):] for l in out.splitlines() if l.startswith("A\t")]


def process(slot, c):
    res = dict(sha=c["sha"], subject=c["subject"], date=c["date"], tier="verbatim")
    inj, mode = G.verbatim_injection(c)
    res["mode"] = mode
    if inj is None:
        return res
    oracle = G.oracle_for(c["sha"])
    res["oracle"] = oracle
    if not oracle:
        res["skip"] = "no-oracle"
        return res
    (G.PATCH_DIR).mkdir(parents=True, exist_ok=True)
    (G.PATCH_DIR / f"{c['sha']}.patch").write_text(inj, errors="surrogateescape")
    res.update(G.gate(slot, inj, oracle, c["sha"][:12]))
    res["fix_added_units"] = added_tests(c["sha"])
    res["fails_added"] = [u for u in res.get("failing", []) if u in res["fix_added_units"]]
    res["gate"] = G.passes_gate(res)
    return res


def control(slot):
    """Null injection on this slot: clean rebuild of the unmodified release must pass
    a fixed sample of base-passing units (both runs)."""
    f = DATA / f"control_s{slot.n}.json"
    if f.exists():
        return json.loads(f.read_text())["ok"]
    base = load("base.json")
    units = sorted(u for u, v in base.items() if v["run1"] == v["run2"] == "passed")[::25]
    res = G.gate(slot, "", units, "control")
    res["ok"] = res.get("build") == "ok" and not res.get("failing") and not res.get("flaky_inj")
    f.write_text(json.dumps(res, indent=1))
    slot.reset()
    return res["ok"]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--slots", type=int, default=4)
    ap.add_argument("--first-slot", type=int, default=1)
    ap.add_argument("--only", default="")
    a = ap.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    probe = {r["sha"]: r for r in load("probe.json")}
    cands = sorted(load("candidates.json"), key=lambda c: -c["ts"])
    if a.only:
        keep = a.only.split(",")
        cands = [c for c in cands if any(c["sha"].startswith(k) for k in keep)]
    else:
        cands = [c for c in cands if probe[c["sha"]]["status"] in ("clean", "fuzzy")]
    def done(c):
        f = OUT / f"{c['sha']}.json"
        return f.exists() and not json.loads(f.read_text()).get("retryable")
    cands = [c for c in cands if not done(c)]
    if a.limit:
        cands = cands[:a.limit]
    print(len(cands), "to process", flush=True)
    q = queue.Queue()
    for c in cands:
        q.put(c)

    def worker(n):
        slot = Slot(n)
        if not slot.prepare():
            print("slot", n, "prepare failed", flush=True)
            return
        if not control(slot):
            print("slot", n, "CONTROL FAILED", flush=True)
            return
        while True:
            try:
                c = q.get_nowait()
            except queue.Empty:
                return
            disk_wait()
            t = time.time()
            try:
                res = process(slot, c)
            except Exception:
                res = dict(sha=c["sha"], error=traceback.format_exc(), retryable=True)
            res["secs"] = round(time.time() - t)
            disk_taint(res)
            (OUT / f"{c['sha']}.json").write_text(json.dumps(res, indent=1))
            print(c["sha"][:10], res.get("mode"), res.get("build"), "fail=", len(res.get("failing", [])),
                  "gate=", res.get("gate"), res.get("skip", ""), res["secs"], "s", flush=True)
            slot.reset()

    ths = [threading.Thread(target=worker, args=(a.first_slot + i,)) for i in range(a.slots)]
    for t in ths:
        t.start()
    for t in ths:
        t.join()


if __name__ == "__main__":
    main()
