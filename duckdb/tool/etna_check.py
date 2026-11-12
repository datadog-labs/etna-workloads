#!/usr/bin/env python3
"""Agent-facing build-and-test loop for one adapted candidate (installed as <slot>/bin/etna-check).

Builds <slot>/src incrementally (no ccache: this tree is private) and runs the candidate's oracle
units once, printing one line per unit: OUTCOME UNIT and a short failure detail.
Exit 0 when at least one oracle unit fails (the goal), 1 when all pass, 2 when the build fails.
"""
import json, os, subprocess, sys
HERE = os.path.dirname(os.path.abspath(__file__))
SLOT = os.path.dirname(HERE)
cfg = json.load(open(os.path.join(HERE, "oracle.json")))
sys.path.insert(0, cfg["tool"])
os.environ["ETNA_RUNTMP"] = os.path.join(SLOT, "runtmp")
os.environ["CCACHE_DISABLE"] = "1"
os.environ["TMPDIR"] = os.path.join(SLOT, "tmp")
os.makedirs(os.environ["TMPDIR"], exist_ok=True)
import runtests

src = os.path.join(SLOT, "src")
log = os.path.join(SLOT, "notes", "last-build.log")
print("building (incremental; usually 2-6 minutes) ...", flush=True)
r = subprocess.run([sys.executable, os.path.join(cfg["tool"], "guard.py"), "--timeout", "7200", "--rss-mb", "40000",
                    "--log", log, "--", os.path.join(cfg["tool"], "build.sh"), src, cfg["version"]],
                   capture_output=True, text=True)
if r.returncode != 0:
    lines = open(log, errors="replace").read().splitlines()
    errs = [l for l in lines if "error" in l.lower()][:30]
    print("BUILD FAILED. First errors (full log: notes/last-build.log):")
    print("\n".join(errs or lines[-40:]))
    sys.exit(2)
print("build ok; running oracle tests ...", flush=True)
res = runtests.run_units(src, cfg["units"], jobs=6, timeout=600)
failing = 0
for u, (o, d) in res.items():
    print(f"{o.upper():8s} {u}")
    if o in runtests.FAILING:
        failing += 1
        print("         " + d[:700].replace("\n", "\n         "))
print(f"\n{failing} of {len(res)} oracle units fail")
sys.exit(0 if failing else 1)
