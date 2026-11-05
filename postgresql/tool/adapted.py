#!/usr/bin/env python3
"""Adapted tier: an agent re-expresses the fix's bug in the release code; the harness gates it.
usage: adapted.py --cap USD --workers W0,W1 [--parallel N] [--limit N] [--only c1,c2] [--model sonnet]"""
import json, os, sys, glob, shutil, subprocess, argparse, threading, queue, time, re
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pgrun, tree, gate, llm
from oracle import oracle_for
from pgpaths import is_impl

W = pgrun.WORK
OUT = f'{W}/state/adapted'
AG = f'{W}/agents'
TOOLS = os.path.dirname(os.path.abspath(__file__))
SETTINGS = f'{TOOLS}/agent_settings.json'

PROMPT = '''You are helping build a dataset of realistic historical bugs for evaluating testing tools.

./src is PostgreSQL at release REL_18_6 (unconfigured source export; a private git index lets you
run `git -C src diff` to see your changes). Upstream commit {short} fixed a bug long ago:

    {subject}

./fix.patch is that commit (message and full diff); ./fix_impl.patch has only its implementation
hunks. The fix is present in REL_18_6, but the code has evolved, so reversing fix_impl.patch
does not apply or no longer reproduces the failure.

YOUR TASK: edit implementation files under ./src (C code, headers, grammar, catalog data, etc.) so
that the release again has the bug this fix removed: re-express the reverse of the fix in today's
code. Rules:
- Every hunk you change must trace to a hunk of fix_impl.patch (same logic, same place in the
  code, adapted to the current code). Do not invent a different bug. Keep the change minimal.
- Never modify tests, expected outputs, test data, test modules (anything under src/test/, t/
  directories, sql/ or expected/ directories), build files (Makefile, meson.build, configure), or
  documentation. The tests must stay exactly as they are.
- Verify with:  python3 {tools}/agent_oracle.py   (configures once, builds, runs the oracle tests
  below and prints PASS/FAIL per case; first run takes a few minutes). At least one oracle case
  must FAIL with your change. With no change, all of them pass. Use --no-build only if you did not
  change code since the last build.
- Oracle cases (ids are dir|tap-file|case): see ./oracle.json ({n} cases), e.g.
{examples}
- When done, write ./RATIONALE.md: for each changed hunk give file and function, the fix.patch
  hunk it traces to, and why it brings back the bug; then list the oracle cases that fail.
- If after honest effort the bug cannot be re-expressed (e.g. the code was rewritten so that the
  bug cannot exist), revert your edits (`git -C src checkout -- .`) and explain why in
  RATIONALE.md, starting the file with the line "NOT REPRODUCIBLE".
Work only inside this directory. No network access is available.
'''

def eligible(cands, probe, triage):
    out = []
    for c in cands:
        t = triage.get(c['commit'], {})
        if t.get('label') != 'bug':
            continue
        v = f'{W}/state/verbatim/{c["commit"]}.json'
        if probe.get(c['commit']) == 'conflict':
            why = 'conflict'
        elif os.path.exists(v) and json.load(open(v))['status'] in ('no_failure', 'build_failed', 'apply_failed'):
            why = 'verbatim-' + json.load(open(v))['status']
        else:
            continue
        oracle, _ = oracle_for(c['test_files'])
        if oracle:
            out.append(dict(c, adapted_reason=why, oracle=oracle))
    out.sort(key=lambda c: c['date'], reverse=True)
    return out

def prepare(c):
    wd = f'{AG}/{c["commit"][:12]}'
    if os.path.exists(wd):
        shutil.rmtree(wd)
    os.makedirs(f'{wd}/tmp')
    tree.init_tree('REL_18_6', f'{wd}/src')
    show = subprocess.run(['git', '-C', pgrun.REPO, 'show', '--no-renames', c['commit']], capture_output=True).stdout
    open(f'{wd}/fix.patch', 'wb').write(show)
    impl = subprocess.run(['git', '-C', pgrun.REPO, 'diff', '--no-renames', c['commit'] + '^', c['commit'], '--'] + c['impl_files'], capture_output=True).stdout
    open(f'{wd}/fix_impl.patch', 'wb').write(impl)
    json.dump(c['oracle'], open(f'{wd}/oracle.json', 'w'), indent=1)
    return wd

def extract(wd):
    t = f'{wd}/src'
    tree.git(t, 'add', '-u')
    names = tree.git(t, 'diff', '--cached', '--name-only', tree.base_tree(t)).stdout.decode().split()
    keep = [n for n in names if is_impl(n) and not os.path.islink(f'{t}/{n}')]
    dropped = [n for n in names if n not in keep]
    patch = tree.git(t, 'diff', '--cached', '--binary', tree.base_tree(t), '--', *keep).stdout if keep else b''
    return patch, keep, dropped

def run_one(c, worker, model, max_turns, stage='adapted'):
    wd = prepare(c)
    short = c['commit'][:12]
    ex = '\n'.join('    ' + x for x in c['oracle'][:8])
    prompt = PROMPT.format(short=short, subject=c['subject'], tools=TOOLS, n=len(c['oracle']), examples=ex)
    env = dict(os.environ, TMPDIR=f'{wd}/tmp')
    t0 = time.time()
    res = dict(commit=c['commit'], date=c['date'], subject=c['subject'], model=model,
               adapted_reason=c['adapted_reason'], oracle=c['oracle'])
    try:
        d = llm.claude(prompt, model, stage, short, cwd=wd, settings=SETTINGS, max_turns=max_turns,
                       timeout=5400, env=env)
    except (llm.RetryableError, RuntimeError) as e:
        res.update(status='api_error', why=str(e))
        pgrun.kill_tree_procs(wd); shutil.rmtree(wd, ignore_errors=True)
        return res
    res.update(agent_cost=d.get('total_cost_usd'), agent_turns=d.get('num_turns'),
               agent_subtype=d.get('subtype'), agent_result=str(d.get('result', ''))[-3000:],
               agent_secs=round(time.time() - t0))
    rat = f'{wd}/RATIONALE.md'
    res['rationale'] = open(rat, errors='replace').read() if os.path.exists(rat) else ''
    patch, keep, dropped = extract(wd)
    res.update(changed_files=keep, dropped_files=dropped)
    res['agent_log_tail'] = open(f'{wd}/logs/oracle.log', errors='replace').read()[-2000:] if os.path.exists(f'{wd}/logs/oracle.log') else ''
    if res['rationale'].startswith('NOT REPRODUCIBLE') or not patch.strip():
        res['status'] = 'agent_gave_up' if res['rationale'].startswith('NOT REPRODUCIBLE') else 'no_patch'
    else:
        log = f'{W}/logs/adapted/{short}.gate.log'
        os.makedirs(os.path.dirname(log), exist_ok=True)
        res.update(gate.gate(worker, patch, c['oracle'], log, allow_fuzz=False))
    pgrun.kill_tree_procs(wd)
    shutil.rmtree(wd, ignore_errors=True)
    return res

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--cap', type=float, required=True); ap.add_argument('--workers', required=True)
    ap.add_argument('--limit', type=int, default=0); ap.add_argument('--only', default='')
    ap.add_argument('--model', default='sonnet'); ap.add_argument('--max-turns', type=int, default=80)
    ap.add_argument('--list', action='store_true')
    ap.add_argument('--stage', default='', help='override the spend-ledger stage name')
    ap.add_argument('--wait-workers', default='', help='workers that start only after verbatim.py exits')
    ap.add_argument('--retry', action='store_true', help='retry no_failure/no_patch results (stage adapted_retry)')
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    probe = {j['commit']: j['apply'] for j in map(json.loads, open(f'{W}/probe_apply.jsonl'))}
    triage = {}
    for p in glob.glob(f'{W}/state/triage/*.json'):
        j = json.load(open(p)); triage[j['commit']] = j
    C = eligible([json.loads(l) for l in open(f'{W}/candidates.jsonl')], probe, triage)
    if a.list:
        print(len(C)); return
    if a.only:
        C = [c for c in C if any(c['commit'].startswith(x) for x in a.only.split(','))]
    stage = a.stage or ('adapted_retry' if a.retry else 'adapted')
    lock = threading.Lock(); taken = set(); done_count = [0]

    def prev(c):
        p = f'{OUT}/{c["commit"]}.json'
        return json.load(open(p)) if os.path.exists(p) else None

    def todo(c):
        p = prev(c)
        if a.retry:
            return bool(p) and p['status'] in ('no_failure', 'no_patch') and p.get('model') != a.model and not p.get('first_attempt')
        return not (p and p['status'] not in ('api_error', 'harness_error'))

    def next_item():
        """Newest eligible item not done and not taken; eligibility is recomputed so verbatim
        failures that appear later join the queue."""
        nonlocal C
        with lock:
            if not a.only and not a.retry:
                C = eligible([json.loads(l) for l in open(f'{W}/candidates.jsonl')], probe, triage)
            for c in C:
                if c['commit'] in taken or os.path.exists(f'{AG}/{c["commit"][:12]}'):
                    continue
                if todo(c):
                    if a.limit and done_count[0] >= a.limit:
                        return None
                    taken.add(c['commit']); done_count[0] += 1
                    return c
        return None

    wait = set(a.wait_workers.split(',')) if a.wait_workers else set()
    def verbatim_running():
        for pid in os.listdir('/proc'):
            try:
                if pid.isdigit() and b'verbatim.py' in open(f'/proc/{pid}/cmdline', 'rb').read().split(b'\0')[1]:
                    return True
            except (OSError, IndexError):
                pass
        return False

    def work(worker):
        name = os.path.basename(worker)
        while name in wait and verbatim_running() and not os.path.exists(f'{W}/STOP'):
            time.sleep(120)
        while not os.path.exists(f'{W}/STOP') and llm.spent(stage) < a.cap:
            c = next_item()
            if c is None: return
            first = prev(c) if a.retry else None
            try:
                r = run_one(c, worker, a.model, a.max_turns, stage)
                if first: r['first_attempt'] = {k: first.get(k) for k in ('status', 'model', 'agent_cost', 'rationale')}
            except Exception as e:
                r = dict(commit=c['commit'], status='harness_error', why=repr(e))
                if not tree.is_pristine(worker): tree.restore(worker)
            json.dump(r, open(f'{OUT}/{c["commit"]}.json', 'w'))
            print(c['commit'][:12], c['date'][:10], r['status'], r.get('agent_cost'), r.get('agent_turns'),
                  len(r.get('failing', [])), round(llm.spent(stage), 2), flush=True)
    ts = [threading.Thread(target=work, args=(f'{W}/w/{w}',)) for w in a.workers.split(',')]
    [t.start() for t in ts]; [t.join() for t in ts]

if __name__ == '__main__':
    main()
