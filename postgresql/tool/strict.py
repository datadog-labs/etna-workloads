#!/usr/bin/env python3
"""Classify every gated bug: tier, triage label, fix-added failing cases, anchor; write state/bugs.json."""
import json, os, sys, glob
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pgrun, fixadded
W = pgrun.WORK

def main():
    tri = {j['commit']: j for j in (json.load(open(p)) for p in glob.glob(f'{W}/state/triage/*.json'))}
    bugs = []
    for tier in ('verbatim', 'adapted'):
        for p in glob.glob(f'{W}/state/{tier}/*.json'):
            r = json.load(open(p))
            if r.get('status') != 'gate_pass':
                continue
            fa = {c: fixadded.classify(r['commit'], c, r.get('runs', []), '') for c in r['failing']}
            t = tri.get(r['commit'], {})
            b = dict(commit=r['commit'], date=r['date'], subject=r['subject'], tier=tier,
                     apply=r.get('apply'), label=t.get('label'), symptom=t.get('symptom'),
                     subsystem=t.get('subsystem'), confidence=t.get('confidence'),
                     failing=r['failing'], fix_added={c: v for c, v in fa.items() if v},
                     n_oracle=len(r['oracle']))
            if tier == 'adapted':
                ap = f'{W}/state/anchor/{r["commit"]}.json'
                a = json.load(open(ap)) if os.path.exists(ap) else {'status': 'not_run'}
                b['anchor'] = a['status']; b['anchor_common'] = a.get('common', [])
                b['model'] = r.get('model')
            reasons = []
            if b['label'] != 'bug': reasons.append(f'triage={b["label"]}')
            if not b['fix_added']: reasons.append('no fix-added failing case')
            if tier == 'adapted' and b['anchor'] != 'exact': reasons.append(f'anchor={b["anchor"]}')
            b['strict'] = not reasons
            b['not_strict_reasons'] = reasons
            bugs.append(b)
    bugs.sort(key=lambda b: b['date'], reverse=True)
    json.dump(bugs, open(f'{W}/state/bugs.json', 'w'), indent=1)
    json.dump([b['commit'] for b in bugs if b['strict']], open(f'{W}/state/strict.json', 'w'))
    print(len(bugs), 'gated;', sum(b['strict'] for b in bugs), 'strict')

if __name__ == '__main__':
    main()
