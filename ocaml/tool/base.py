"""Run every needed unit twice on the base (slot 0, freshly reset). -> data/base.json"""
import sys, time
from collections import Counter
from common import *
from slots import Slot

def main():
    par = int(sys.argv[1]) if len(sys.argv) > 1 else 8
    m = load("testmap.json")
    need = sorted({u for v in m.values() for u in v["units"]})
    s = Slot(0)
    assert s.prepare()
    s.reset()
    base = load("base.json", {})
    for run in ("run1", "run2"):
        todo = [u for u in need if run not in base.get(u, {})]
        t = time.time()
        res = s.run_units(todo, tag="base" + run, par=par)
        for u, (st, det) in res.items():
            base.setdefault(u, {})[run] = st
            if st != "passed":
                base[u][run + "_detail"] = det[-3000:]
        save("base.json", base)
        print(run, len(todo), "units in", round(time.time() - t), "s",
              Counter(base[u][run] for u in need), flush=True)
    both = Counter((base[u]["run1"], base[u]["run2"]) for u in need)
    print(both)

if __name__ == "__main__":
    main()
