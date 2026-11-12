#!/usr/bin/env python3
"""Agent-facing reproducer check (installed as <slot>/bin/repro-check FILE.sql).
Runs FILE.sql with the clean (base) and the injected (this slot) DuckDB shells exactly as the harness
does and reports whether it is accepted."""
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
SLOT = os.path.dirname(HERE)
cfg = json.load(open(os.path.join(HERE, "repro.json")))
sys.path.insert(0, cfg["tool"])
os.environ["ETNA_WORK"] = cfg["work"]
import common, repro
common_runtmp = os.path.join(SLOT, "runtmp"); os.makedirs(common_runtmp, exist_ok=True)
repro.RUNTMP = common_runtmp
sql = open(sys.argv[1]).read()
v = repro.verify(sql, cfg["clean"], os.path.join(SLOT, "src"))
if v["ok"]:
    print("ACCEPTED: output/exit status differ and the clean output is deterministic.")
    print("--- clean (exit %s) ---\n%s\n--- injected (exit %s) ---\n%s" % (v["clean_status"], v["clean_out"][-2500:], v["injected_status"], v["injected_out"][-2500:]))
    sys.exit(0)
print("REJECTED:", v["why"])
for k in ("clean_out",):
    if k in v:
        print(v[k][-2000:])
sys.exit(1)
