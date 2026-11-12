"""One verbatim-tier candidate: reverse the fix's src/ hunks in a slot, gate, mechanical reproducer."""
import json, os, shutil, time
import common, gate, repro


def run_one(slot, c, base, umap, jobs=6):
    out = os.path.join(common.RESULTS, "verbatim", c["sha"])
    rp = os.path.join(out, "result.json")
    shutil.rmtree(out, ignore_errors=True); os.makedirs(out)
    t0 = time.time()
    res = {"sha": c["sha"], "subject": c["subject"], "tier": "verbatim", "slot": slot}
    units = umap.get(c["sha"], {}).get("units", [])
    oracle = [u for u in units if base.get(u) == "pass"]
    res["units"] = len(units); res["oracle"] = oracle
    res["added_units"] = umap.get(c["sha"], {}).get("added", [])
    if not oracle:
        res["verdict"] = "no-oracle"; common.write_json(rp, res); return res
    common.sync_tree(slot)
    how = gate.apply_patch(slot, common.impl_diff(c["sha"], c["parent"]), reverse=True, fuzz=True)
    if not how:
        res["verdict"] = "apply-fail"; common.write_json(rp, res); common.sync_tree(slot); return res
    res["apply"] = how
    inj = common.tree_diff(common.PRISTINE, slot)
    open(os.path.join(out, "injection.patch"), "wb").write(inj)
    if not inj.strip():
        res["verdict"] = "empty-injection"; common.write_json(rp, res); return res

    def make_repro(tree, r):
        details = {u: r["runs"][0][u][1] for u in r["failing"]}
        rep, attempts = repro.mechanical(common.BASE, tree, r["failing"], details)
        if rep:
            open(os.path.join(out, "repro.sql"), "w").write(rep["sql"])
        return {"repro": rep, "repro_attempts": attempts}
    try:
        res.update(gate.gate(slot, inj, oracle, out, jobs=jobs, on_injected=make_repro))
    finally:
        common.sync_tree(slot)  # leave the slot at the release whatever happened
    res["wall_secs"] = round(time.time() - t0, 1)
    common.write_json(rp, res)
    return res
