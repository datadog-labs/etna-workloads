#!/usr/bin/env python3
"""Verbatim tier: reverse the fix's implementation hunks on the release and run the gate.
Usage: verbatim.py CANDIDATES.jsonl PROBE.jsonl NWORKERS [LIMIT] [--only c1,c2]"""
import json, os, sys, queue, threading, subprocess, argparse
sys.path.insert(0, os.path.dirname(__file__))
import pgrun, tree, gate
from oracle import oracle_for

W = pgrun.WORK
OUT = f'{W}/state/verbatim'

def reverse_impl_patch(c):
    return subprocess.run(['git', '-C', pgrun.REPO, 'diff', '--binary', '--no-renames', c['commit'], c['commit'] + '^', '--']
                          + c['impl_files'], capture_output=True, check=True).stdout

def process(i, c):
    t = f'{W}/w/w{i}'
    log = f'{W}/logs/verbatim/{c["commit"][:12]}.log'
    os.makedirs(os.path.dirname(log), exist_ok=True)
    oracle, info = oracle_for(c['test_files'])
    res = dict(commit=c['commit'], date=c['date'], subject=c['subject'], oracle=oracle, oracle_info=info)
    if not oracle:
        res['status'] = 'no_oracle'
    else:
        res.update(gate.gate(t, reverse_impl_patch(c), oracle, log))
    json.dump(res, open(f'{OUT}/{c["commit"]}.json', 'w'))
    return res

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('cands'); ap.add_argument('probe'); ap.add_argument('nworkers', type=int)
    ap.add_argument('--limit', type=int, default=0); ap.add_argument('--only', default='')
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    probe = {j['commit']: j['apply'] for j in map(json.loads, open(a.probe))}
    C = [json.loads(l) for l in open(a.cands)]
    C = [c for c in C if probe.get(c['commit']) in ('clean', 'fuzzy')]
    if a.only:
        C = [c for c in C if any(c['commit'].startswith(x) for x in a.only.split(','))]
    C.sort(key=lambda c: c['date'], reverse=True)          # newest first
    C = [c for c in C if not os.path.exists(f'{OUT}/{c["commit"]}.json')]
    if a.limit: C = C[:a.limit]
    q = queue.Queue(); [q.put(c) for c in C]
    stop = f'{W}/STOP'
    def work(i):
        while not os.path.exists(stop):
            try: c = q.get_nowait()
            except queue.Empty: return
            try:
                r = process(i, c)
                print(c['commit'][:12], c['date'][:10], r['status'], r.get('apply'), len(r.get('oracle', [])),
                      len(r.get('failing', [])), r.get('secs'), flush=True)
            except Exception as e:
                print(c['commit'][:12], 'ERROR', repr(e), flush=True)
                if not tree.is_pristine(f'{W}/w/w{i}') and not tree.restore(f'{W}/w/w{i}'):
                    print('worker', i, 'cannot be restored; stopping it', flush=True); return
    ts = [threading.Thread(target=work, args=(i,)) for i in range(a.nworkers)]
    [t.start() for t in ts]; [t.join() for t in ts]

if __name__ == '__main__':
    main()
