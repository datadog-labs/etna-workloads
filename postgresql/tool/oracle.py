"""Oracle computation from two base runs, and unit selection for a candidate."""
import json, os, glob, subprocess, functools
import pgrun
from units import map_test_file, case_id, unit_of_case

BASE = f'{pgrun.WORK}/state/base'
def ukey(u): return '__'.join(x.replace('/', '_') for x in u if x)

@functools.lru_cache(None)
def release_files():
    return frozenset(subprocess.run(['git', '-C', pgrun.REPO, 'ls-tree', '-r', '--name-only', 'REL_18_6'],
                                    capture_output=True, text=True).stdout.split())

@functools.lru_cache(None)
def base_result(unit):
    """{case_name: 'pass'|'fail'|'flaky'|'skip'|'missing'} combining both base rounds; None if not run."""
    rs = []
    for rnd in (1, 2):
        p = f'{BASE}/r{rnd}/{ukey(unit)}.json'
        if not os.path.exists(p):
            return None
        rs.append(json.load(open(p))['cases'])
    out = {}
    for name in set(rs[0]) | set(rs[1]):
        a, b = rs[0].get(name, 'missing'), rs[1].get(name, 'missing')
        out[name] = a if a == b else 'flaky'
    return out

def candidate_units(test_files, files=None):
    """Map a fix's test files (as present in `files`, default: the release) to {unit: set(names) or None=all}."""
    files = release_files() if files is None else files
    units = {}
    for t in test_files:
        if t not in files:
            continue
        r = map_test_file(t)
        if not r:
            continue
        u, name = r
        if name is None:
            units[u] = None
        elif units.get(u, set()) is not None:
            units.setdefault(u, set()).add(name)
    return units

def oracle_for(test_files):
    """Return (oracle case ids, info) using two base runs."""
    cases, info = [], {}
    for u, names in candidate_units(test_files).items():
        b = base_result(u)
        if b is None:
            info[ukey(u)] = 'no-base-run'; continue
        sel = b if names is None else {n: b.get(n, 'missing') for n in names}
        for n, st in sel.items():
            if st == 'pass':
                cases.append(case_id(u, n))
            else:
                info[case_id(u, n)] = st
    return sorted(cases), info

def units_of(cases):
    us = []
    for c in cases:
        u = unit_of_case(c)
        if u not in us: us.append(u)
    return us
