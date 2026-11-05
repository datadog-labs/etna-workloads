#!/usr/bin/env python3
"""Re-run the gate for stored injections (no agent, no API) -- used after the /dev/shm incident.
usage: regate.py TIER --since 'YYYY-MM-DD HH:MM' --workers w0,w1,..."""
import json, os, sys, glob, argparse, threading, queue, datetime, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pgrun, tree, gate
W = pgrun.WORK
SHM = re.compile(r'could not resize shared memory segment|No space left on device|could not create shared memory segment')

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('tier'); ap.add_argument('--since', required=True)
    ap.add_argument('--workers', required=True); ap.add_argument('--statuses', default='gate_pass')
    a = ap.parse_args()
    since = datetime.datetime.strptime(a.since, '%Y-%m-%d %H:%M').timestamp()
    todo = []
    for p in glob.glob(f'{W}/state/{a.tier}/*.json'):
        r = json.load(open(p))
        if r.get('status') in a.statuses.split(',') and r.get('stored') and os.path.getmtime(p) >= since and not r.get('regated'):
            todo.append(p)
    todo.sort(key=lambda p: json.load(open(p))['date'], reverse=True)
    print(len(todo), 'to re-gate', flush=True)
    q = queue.Queue(); [q.put(p) for p in todo]
    def work(w):
        t = f'{W}/w/{w}'
        while not os.path.exists(f'{W}/STOP'):
            try: p = q.get_nowait()
            except queue.Empty: return
            r = json.load(open(p))
            log = f'{W}/logs/regate/{r["commit"][:12]}.log'; os.makedirs(os.path.dirname(log), exist_ok=True)
            g = gate.gate(t, r['stored'].encode('utf-8', errors='surrogateescape'), r['oracle'], log, allow_fuzz=False)
            shm = any(SHM.search(json.dumps(x.get('diffs', {})) + x.get('tail', '')) for x in g.get('runs', []))
            old = {k: r.get(k) for k in ('status', 'failing')}
            r.update({k: v for k, v in g.items() if k != 'stored'})
            r['regated'] = True; r['pre_regate'] = old
            if shm: r['status'] = 'invalid_shm'
            json.dump(r, open(p, 'w'))
            print(r['commit'][:12], old['status'], '->', r['status'], len(r.get('failing', [])), flush=True)
    ts = [threading.Thread(target=work, args=(w,)) for w in a.workers.split(',')]
    [x.start() for x in ts]; [x.join() for x in ts]

if __name__ == '__main__':
    main()
