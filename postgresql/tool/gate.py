"""The gate: apply injection, build, run oracle units twice, reverse and verify byte-for-byte."""
import json, os, time
import pgrun, tree
from oracle import units_of, base_result
from units import case_id, unit_of_case

def run_oracle(t, cases, log, reps=2, keep_diffs=True):
    """Run the units of `cases` `reps` times. Returns (per-case list of statuses, run records)."""
    units = units_of(cases)
    per = {c: [] for c in cases}
    runs = []
    for rep in range(reps):
        for u in units:
            r = pgrun.run_unit(t, u, log, timeout=unit_timeout(u))
            runs.append(dict(unit=u, rep=rep, rc=r['rc'], secs=r['secs'], ncases=len(r['cases']),
                             diffs=r['diffs'] if keep_diffs else {}, tail=r['tail'][-1500:]))
            for c in cases:
                if unit_of_case(c) == u:
                    per[c].append(r['cases'].get(c.split('|', 2)[2], 'missing'))
    return per, runs

def unit_timeout(u):
    import glob
    from oracle import ukey, BASE
    secs = [json.load(open(p))['secs'] for p in glob.glob(f'{BASE}/r*/{ukey(u)}.json')]
    return int(max(300, 4 * max(secs or [300])))

def gate(t, patch, oracle_cases, log, allow_fuzz=True, build_jobs=4):
    """Returns a result dict; tree is always left pristine (or result['restore_failed'])."""
    res = dict(t0=time.time())
    assert tree.is_pristine(t), 'worker not pristine before gate'
    method, stored = tree.apply(t, patch, allow_fuzz)
    if method is None:
        res.update(status='apply_failed', why=stored[:1500])
        return res
    res['apply'] = method
    res['stored'] = stored.decode('utf-8', errors='surrogateescape')
    rc = pgrun.build(t, log, build_jobs)
    if rc != 0:
        res['status'] = 'build_failed'
        with open(log, errors='replace') as f: res['build_tail'] = f.read()[-3000:]
    else:
        per, runs = run_oracle(t, oracle_cases, log)
        res['per_case'] = per
        res['runs'] = runs
        res['failing'] = sorted(c for c, v in per.items() if v and all(x in ('fail', 'missing') for x in v))
        res['flaky_injected'] = sorted(c for c, v in per.items() if len(set(x == 'pass' for x in v)) > 1)
        res['status'] = 'gate_pass' if res['failing'] else 'no_failure'
    ok = tree.reverse(t, stored)
    res['reverse_ok'] = ok
    if not ok:
        res['restore_failed'] = not tree.restore(t)
        if res['status'] == 'gate_pass':
            res['status'] = 'reverse_failed'
    res['secs'] = round(time.time() - res.pop('t0'), 1)
    return res
