#!/usr/bin/env python3
"""Run every needed unit twice on the pristine release (workers w0..wN-1). Resumable."""
import json, os, sys, queue, threading
sys.path.insert(0, os.path.dirname(__file__))
import pgrun, tree

W = pgrun.WORK
STATE = f'{W}/state/base'
def ukey(u): return '__'.join(x.replace('/', '_') for x in u if x) or 'x'

def main(units, nworkers, rounds=(1, 2)):
    for rnd in rounds:
        os.makedirs(f'{STATE}/r{rnd}', exist_ok=True)
        q = queue.Queue()
        # longest-first heuristic: TAP in src/test/recovery & subscription first
        for u in sorted(units, key=lambda u: (u[1].startswith(('src/test/recovery', 'src/test/subscription')) is False, u)):
            if not os.path.exists(f'{STATE}/r{rnd}/{ukey(u)}.json'):
                q.put(tuple(u))
        def work(i):
            t = f'{W}/w/w{i}'
            assert tree.is_pristine(t)
            while True:
                try: u = q.get_nowait()
                except queue.Empty: return
                r = pgrun.run_unit(t, u, f'{W}/logs/base.w{i}.log')
                r['unit'] = u; r['round'] = rnd
                json.dump(r, open(f'{STATE}/r{rnd}/{ukey(u)}.json', 'w'))
                print(rnd, u, r['rc'], r['secs'], len(r['cases']), sum(v == 'fail' for v in r['cases'].values()), flush=True)
        ts = [threading.Thread(target=work, args=(i,)) for i in range(nworkers)]
        [t.start() for t in ts]; [t.join() for t in ts]

if __name__ == '__main__':
    units = json.load(open(sys.argv[1]))
    main(units, int(sys.argv[2]))
