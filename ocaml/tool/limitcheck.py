"""Run every base-passing unit on the clean release under the 8 GB RLIMIT_AS that the
harness applied since 2026-11-03 19:00, to find units the limit alone breaks."""
import json, time
from common import *
from slots import Slot
s = Slot(0)
s.reset()
base = load("base.json")
units = sorted(u for u, v in base.items() if v["run1"] == v["run2"] == "passed")
t = time.time()
res = s.run_units(units, tag="lim", par=8)
bad = {u: r[0] for u, r in res.items() if r[0] != "passed"}
save("limitcheck.json", dict(units=len(units), bad=bad, detail={u: res[u][1][-800:] for u in bad}))
print(len(units), "units;", len(bad), "not passing under the limit:", bad, round(time.time() - t), "s")
