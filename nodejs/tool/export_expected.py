#!/usr/bin/env python3
"""Write bugs/<id>/repro.expected.json from a fresh clean checkout's build, using the
workload's own bin/etna.py normalisation; each reproducer runs twice and must agree."""
import importlib.util, json, os, sys
wl, co = sys.argv[1], sys.argv[2]
spec = importlib.util.spec_from_file_location("etna", os.path.join(wl, "bin", "etna.py"))
etna = importlib.util.module_from_spec(spec); spec.loader.exec_module(etna)
node = os.path.join(os.path.abspath(co), "out/Release/node")
ok = bad = 0
for bid in sorted(os.listdir(os.path.join(wl, "bugs"))):
    d = os.path.join(wl, "bugs", bid)
    m = json.load(open(os.path.join(d, "meta.json")))
    if not m.get("reproducer"):
        continue
    script = os.path.join(d, m["reproducer"]["file"])
    r1, r2 = etna.run_repro(script, node), etna.run_repro(script, node)
    if r1 != r2:
        bad += 1
        m["reproducer_note"] = "dropped: nondeterministic on the fresh clean build"
        m["reproducer"] = None
        os.remove(script)
        json.dump(m, open(os.path.join(d, "meta.json"), "w"), indent=2)
        continue
    json.dump({"output": r1[0], "exit": r1[1]}, open(os.path.join(d, "repro.expected.json"), "w"), indent=1)
    ok += 1
print(f"expected written: {ok}; dropped (nondeterministic): {bad}")
