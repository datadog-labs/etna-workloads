#!/usr/bin/env python3
"""Re-check every accepted reproducer after the read-only-base fix (clean runs now use a writable private root).
Phase 1: rerun the clean side twice; unchanged clean output/status -> the original acceptance stands
         (the injected side always ran in a writable slot).
Phase 2 (--slot S): for changed ones, rebuild the injection in slot S and re-verify fully; on failure the
         reproducer is withdrawn (kept as repro.withdrawn.sql, with the reason).
Writes results/repro_reverify.json."""
import argparse, json, os, shutil
from concurrent.futures import ThreadPoolExecutor
import common, gate, repro

ap = argparse.ArgumentParser(); ap.add_argument("--slot"); a = ap.parse_args()
items = []
for tier in ("verbatim", "adapted"):
    for s in os.listdir(f"{common.RESULTS}/{tier}"):
        p = f"{common.RESULTS}/{tier}/{s}/result.json"
        if "." in s or not os.path.exists(p):
            continue
        r = json.load(open(p))
        if r.get("verdict") == "pass" and r.get("repro"):
            items.append((tier, s, p, r))
out_p = f"{common.RESULTS}/repro_reverify.json"
state = json.load(open(out_p)) if os.path.exists(out_p) else {}


def clean_check(it):
    tier, s, p, r = it
    d = f"{common.WORK}/scratch/rv/{s}"; os.makedirs(d, exist_ok=True)
    f = os.path.join(d, "repro.sql"); open(f, "w").write(r["repro"]["sql"])
    c1 = repro.run_script(common.BASE, f); c2 = repro.run_script(common.BASE, f)
    same = c1 == c2 and c1[0] == str(r["repro"]["clean_status"]) and c1[1] == r["repro"]["clean_out"]
    return s, {"tier": tier, "clean_unchanged": same, "deterministic": c1 == c2}

todo = [it for it in items if it[1] not in state]
with ThreadPoolExecutor(8) as ex:
    for s, v in ex.map(clean_check, todo):
        state[s] = v
common.write_json(out_p, state)
changed = [it for it in items if not state[it[1]]["clean_unchanged"]]
print(len(items), "reproducers;", len(changed), "with a changed clean side")
if a.slot:
    src = os.path.abspath(a.slot)
    for tier, s, p, r in changed:
        if state[s].get("reverified") is not None:
            continue
        rdir = os.path.dirname(p)
        common.sync_tree(src)
        gate.apply_patch(src, open(os.path.join(rdir, "injection.patch"), "rb").read())
        b = gate.build(src, os.path.join(rdir, "reverify-build.log"))
        v = repro.verify(r["repro"]["sql"], common.BASE, src) if b["status"] == "exit" and b["rc"] == 0 else {"ok": False, "why": "build failed"}
        common.sync_tree(src)
        state[s]["reverified"] = v["ok"]; state[s]["why"] = v.get("why")
        if v["ok"]:
            r["repro"].update({k: v[k] for k in ("clean_status", "clean_out", "injected_status", "injected_out")})
        else:
            if os.path.exists(os.path.join(rdir, "repro.sql")):
                shutil.move(os.path.join(rdir, "repro.sql"), os.path.join(rdir, "repro.withdrawn.sql"))
            r["repro_withdrawn"] = {"reason": "accepted against a read-only clean tree; fails re-verification: " + str(v.get("why")),
                                    "method": r["repro"].get("method")}
            r["repro"] = None
        r["repro_reverified"] = True
        common.write_json(p, r); common.write_json(out_p, state)
        print(s[:10], "reverified" if v["ok"] else "withdrawn: " + str(v.get("why")), flush=True)
