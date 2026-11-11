#!/usr/bin/env python3
"""Re-check gated bugs whose failing cases are ALL timeouts, at low machine load and with long limits
(10x base time, min 300s).  A bug is demoted (status 'timeout_not_confirmed') if any rerun passes.
Writes data/timeout_recheck.json and updates the tier records in place (original kept in 'gate_status_before')."""
import os, sys, json, time
sys.path.insert(0, os.path.dirname(__file__))
from gate import *

SLOT = 0


def main():
    out = {}
    ensure_slot(SLOT, os.path.join(WORK, "logs", "recheck.setup.log"))
    s, src, build = slot_paths(SLOT)
    for tier in ("verbatim", "adapted"):
        d = os.path.join(DATA, tier)
        for f in sorted(os.listdir(d)):
            if f.endswith(".sonnet.json"):
                continue
            p = os.path.join(d, f)
            r = json.load(open(p))
            if r.get("status") != "pass_gate":
                continue
            to = [u for u in r["failing"] if all(x["detail"] == "timeout" for x in r["results"][u])]
            if not to or len(to) != len(r["failing"]):
                continue
            reset_slot(SLOT)
            rr = subprocess.run(["git", "apply"], cwd=src, input=r["injection"], text=True, capture_output=True)
            st, _ = ninja(build, os.path.join(WORK, "logs", "recheck.log"), jobs=8)
            res = {}
            for u in to:
                bt = base_units()[u]["max_secs"]
                lim = int(max(300, 10 * bt))
                res[u] = [run_case(build, u, lim) for _ in range(2)]
                res[u] = [{k: x[k] for k in ("status", "detail", "secs")} | {"limit": lim} for x in res[u]]
            confirmed = all(all(x["status"] == "fail" for x in rs) for rs in res.values()) and st == "ok"
            out[r["sha"]] = dict(tier=tier, units=to, build=st, results=res, confirmed=confirmed)
            print(tier, r["sha"][:10], to, "confirmed" if confirmed else "NOT confirmed", flush=True)
            if not confirmed:
                r["gate_status_before"] = r["status"]
                r["status"] = "timeout_not_confirmed"
                r["timeout_recheck"] = out[r["sha"]]
                json.dump(r, open(p, "w"), indent=1)
    reset_slot(SLOT)
    json.dump(out, open(os.path.join(DATA, "timeout_recheck.json"), "w"), indent=1)


if __name__ == "__main__":
    main()
