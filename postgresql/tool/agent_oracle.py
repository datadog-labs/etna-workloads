#!/usr/bin/env python3
"""Agent-side helper: build the tree in ./src and run the oracle units; print per-case results.
usage: agent_oracle.py [--no-build] [--reps N]   (run from the agent work directory)"""
import json, os, sys, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
WD = os.getcwd()
os.environ.setdefault('ETNA_PORT_DIR', f'{WD}/portlock')
import pgrun
from units import unit_of_case

def main():
    reps = int(sys.argv[sys.argv.index('--reps') + 1]) if '--reps' in sys.argv else 1
    t = f'{WD}/src'; log = f'{WD}/logs/oracle.log'
    os.makedirs(f'{WD}/logs', exist_ok=True)
    open(log, 'w').close()
    if not os.path.exists(f'{t}/config.status'):
        print('configuring ...', flush=True)
        if pgrun.configure(t, log) != 0:
            print('CONFIGURE FAILED; see logs/oracle.log'); sys.exit(2)
    if '--no-build' not in sys.argv:
        print('building ...', flush=True)
        if pgrun.build(t, log, 8) != 0:
            os.system(f"grep -E 'error|Error' {log} | head -30")
            print('BUILD FAILED; see logs/oracle.log'); sys.exit(2)
    oracle = json.load(open(f'{WD}/oracle.json'))
    units = []
    for c in oracle:
        u = unit_of_case(c)
        if u not in units: units.append(u)
    res = collections.defaultdict(list)
    for rep in range(reps):
        for u in units:
            print(f'running {u[1]} {u[2]} ...', flush=True)
            r = pgrun.run_unit(t, u, log)
            for c in oracle:
                if unit_of_case(c) == u:
                    res[c].append(r['cases'].get(c.split('|', 2)[2], 'missing'))
            for k, v in r['diffs'].items():
                open(f'{WD}/logs/{k.replace("/", "_")}.diffs', 'w').write(v)
    nf = 0
    for c in oracle:
        st = 'FAIL' if all(x != 'pass' for x in res[c]) else 'pass'
        nf += st == 'FAIL'
        print(f'{st:5} {c}  {res[c]}')
    print(f'oracle cases failing: {nf}/{len(oracle)}  (diffs, if any, in logs/*.diffs; full log logs/oracle.log)')

main()
