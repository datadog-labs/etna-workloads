"""Re-verify stored reproducers (sources only) in a slot: reverify_repro.py SLOT sha..."""
import json, shutil, sys
from common import *
from slots import Slot
import repro

slot = Slot(int(sys.argv[1]))
slot.prepare()
for k in sys.argv[2:]:
    f = next((DATA / "repro").glob(k + "*.json"))
    res = json.loads(f.read_text())
    sha = res["sha"]
    src = DATA / "repro_files" / sha
    tmp = DATA / "repro_files" / (sha + ".new")
    repro.keep_sources(src, tmp)
    shutil.rmtree(src)
    tmp.rename(src)
    pd = DATA / ("patches" if res["tier"] == "verbatim" else "patches_adapted")
    inj = (pd / f"{sha}.patch").read_text(errors="surrogateescape")
    for k2 in ("clean", "buggy", "deterministic", "verified", "why"):
        res.pop(k2, None)
    res["files"] = sorted(p.name for p in src.iterdir())
    res.update(repro.verify(slot, src, inj))
    res["reverified"] = True
    f.write_text(json.dumps(res, indent=1))
    print(sha[:10], res["files"], res["verified"], res.get("why", ""), res["clean"][0], res["buggy"][0], flush=True)
    slot.reset()
