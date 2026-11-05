#!/usr/bin/env python3
"""Reproducer stage: build the injected install, let an agent write a standalone reproducer,
verify it with repro_check.py (harness, never the agent's word).
usage: repro.py --cap USD --workers w4,w5 [--limit N] [--only ...] [--model sonnet]"""
import json, os, sys, glob, shutil, subprocess, argparse, threading, queue, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pgrun, tree, llm

W = pgrun.WORK
OUT = f'{W}/state/repro'
TOOLS = os.path.dirname(os.path.abspath(__file__))
CLEAN = f'{W}/inst/clean/usr/local/pgsql/bin'
SETTINGS = f'{TOOLS}/agent_settings.json'

PROMPT = '''You are writing a standalone reproducer for a bug injected into PostgreSQL 18.6.

Two installed builds exist (read-only for you):
  clean:    {clean}
  injected: {inj}
The injected build differs from the clean one only by ./injection.patch, which re-introduces the
bug fixed by upstream commit {short} ("{subject}"; message and diff in ./fix.patch). The
regression tests that detect it, and how they fail, are in ./failing_tests.txt.

Write ONE reproducer file in this directory: ./repro.sql (preferred; run with `psql -X -a -q -f`
against a fresh cluster, database "postgres", superuser, ON_ERROR_STOP off) or ./repro.sh (run with
`sh`; PATH has the build's bin dir; PGHOST/PGPORT/PGDATABASE/PGDATA point at a fresh running
cluster; you may create extra clusters with initdb/pg_ctl under $PWD-relative temp dirs, using
unix sockets only). Requirements:
- Its output (or exit status) must differ between the clean and the injected build, and be
  deterministic on the clean build. A server crash or assertion failure on the injected build counts.
- Do not print or depend on version strings, build paths, timestamps, pids, random values or OIDs
  (the checker rejects version(), now(), random(), pg_backend_pid(), etc.).
- Keep it short and focused on the bug's behaviour, ideally derived from the failing tests.
Check it with:  python3 {tools}/repro_check.py {clean} {inj} ./repro.sql   (or ./repro.sh)
It prints {{"ok": true, ...}} when the reproducer is accepted. Iterate until it is accepted, or
give up after honest effort and write ./NOTES.md explaining why. Work only in this directory.
'''

def gated():
    out = []
    for tier in ('verbatim', 'adapted'):
        for p in glob.glob(f'{W}/state/{tier}/*.json'):
            r = json.load(open(p))
            if r.get('status') == 'gate_pass':
                out.append(dict(r, tier=tier))
    out.sort(key=lambda r: r['date'], reverse=True)
    return out

def failing_text(r):
    lines = [f"Failing oracle cases: {', '.join(r['failing'][:30])}\n"]
    for run in r.get('runs', [])[:len(r.get('runs', [])) // 2 or 1]:
        for k, v in (run.get('diffs') or {}).items():
            lines.append(f'--- regression diffs ({k}) ---\n{v[:12000]}\n')
        if run['unit'][0] == 'tap':
            lines.append(f"--- TAP output tail for {run['unit'][1]}/{run['unit'][2]} ---\n{run.get('tail','')}\n")
    return ''.join(lines)

def build_injected(worker, r, dest):
    stored = r['stored'].encode('utf-8', errors='surrogateescape')
    method, s2 = tree.apply(worker, stored, allow_fuzz=False)
    if method is None:
        return False
    log = f'{W}/logs/repro/{r["commit"][:12]}.build.log'
    ok = pgrun.build(worker, log, 4) == 0 and pgrun.sh(['make', '-s', 'install', f'DESTDIR={dest}'], worker,
                                                        pgrun.env_for(worker), log, 1200) == 0
    assert tree.reverse(worker, s2)
    return ok

def run_one(r, worker, model, max_turns):
    short = r['commit'][:12]
    wd = f'{W}/repro_agents/{short}'
    inst = f'{W}/inst/{short}'
    shutil.rmtree(wd, ignore_errors=True); shutil.rmtree(inst, ignore_errors=True)
    os.makedirs(f'{wd}/tmp'); os.makedirs(os.path.dirname(f'{W}/logs/repro/x'), exist_ok=True)
    res = dict(commit=r['commit'], tier=r['tier'], model=model)
    if not build_injected(worker, r, inst):
        res['status'] = 'injected_build_failed'; return res
    inj = f'{inst}/usr/local/pgsql/bin'
    open(f'{wd}/injection.patch', 'w').write(r['stored'])
    open(f'{wd}/fix.patch', 'wb').write(subprocess.run(['git', '-C', pgrun.REPO, 'show', r['commit']], capture_output=True).stdout)
    open(f'{wd}/failing_tests.txt', 'w').write(failing_text(r))
    prompt = PROMPT.format(clean=CLEAN, inj=inj, short=short, subject=r['subject'], tools=TOOLS)
    env = dict(os.environ, TMPDIR=f'{wd}/tmp')
    try:
        d = llm.claude(prompt, model, 'repro', short, cwd=wd, settings=SETTINGS, max_turns=max_turns, timeout=3600, env=env)
    except llm.RetryableError as e:
        res.update(status='api_error', why=str(e)); return res
    res.update(agent_cost=d.get('total_cost_usd'), agent_turns=d.get('num_turns'), agent_subtype=d.get('subtype'),
               agent_result=str(d.get('result', ''))[-2000:])
    pgrun.kill_tree_procs(wd)
    files = [f for f in ('repro.sql', 'repro.sh') if os.path.exists(f'{wd}/{f}')]
    if not files:
        res['status'] = 'no_reproducer'
        res['notes'] = open(f'{wd}/NOTES.md', errors='replace').read()[:3000] if os.path.exists(f'{wd}/NOTES.md') else ''
    else:
        f = f'{wd}/{files[0]}'
        env2 = dict(os.environ, TMPDIR=f'{wd}/tmp')
        p = subprocess.run([sys.executable, f'{TOOLS}/repro_check.py', CLEAN, inj, f, f'{wd}/expected_clean.out'],
                           capture_output=True, text=True, env=env2)
        chk = json.loads(p.stdout.strip().splitlines()[-1]) if p.stdout.strip() else dict(ok=False, why=p.stderr[-500:])
        res.update(check=chk, repro_name=files[0], repro=open(f, errors='replace').read(),
                   status='verified' if chk.get('ok') else 'rejected')
        if chk.get('ok'):
            res['expected_clean'] = open(f'{wd}/expected_clean.out', errors='replace').read()
            q = subprocess.run([f'{TOOLS}/repro_run.sh', inj, f, f'{wd}/inj.out'], capture_output=True, env=env2)
            res['expected_injected'] = open(f'{wd}/inj.out', errors='replace').read()
            res['injected_rc'] = q.returncode
    shutil.rmtree(wd, ignore_errors=True); shutil.rmtree(inst, ignore_errors=True)
    return res

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--cap', type=float, required=True); ap.add_argument('--workers', required=True)
    ap.add_argument('--limit', type=int, default=0); ap.add_argument('--only', default='')
    ap.add_argument('--model', default='sonnet'); ap.add_argument('--max-turns', type=int, default=50)
    ap.add_argument('--filter', default='', help='json file with list of commits to include (e.g. strict)')
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    R = gated()
    if a.filter:
        keep = set(json.load(open(a.filter))); R = [r for r in R if r['commit'] in keep]
    if a.only:
        R = [r for r in R if any(r['commit'].startswith(x) for x in a.only.split(','))]
    R = [r for r in R if not (os.path.exists(f'{OUT}/{r["commit"]}.json') and json.load(open(f'{OUT}/{r["commit"]}.json'))['status'] != 'api_error')]
    if a.limit: R = R[:a.limit]
    q = queue.Queue(); [q.put(r) for r in R]
    def work(w):
        while not os.path.exists(f'{W}/STOP') and llm.spent('repro') < a.cap:
            try: r = q.get_nowait()
            except queue.Empty: return
            try:
                res = run_one(r, f'{W}/w/{w}', a.model, a.max_turns)
            except Exception as e:
                res = dict(commit=r['commit'], status='harness_error', why=repr(e))
                if not tree.is_pristine(f'{W}/w/{w}'): tree.restore(f'{W}/w/{w}')
            json.dump(res, open(f'{OUT}/{r["commit"]}.json', 'w'))
            print(r['commit'][:12], r['tier'], res['status'], res.get('agent_cost'), res.get('check', {}).get('why'),
                  round(llm.spent('repro'), 2), flush=True)
    ts = [threading.Thread(target=work, args=(w,)) for w in a.workers.split(',')]
    [t.start() for t in ts]; [t.join() for t in ts]

if __name__ == '__main__':
    main()
