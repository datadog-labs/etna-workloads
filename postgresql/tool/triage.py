#!/usr/bin/env python3
"""Triage every candidate with a cheap model. usage: triage.py CANDS.jsonl CAP_USD [BATCH]"""
import json, os, sys, subprocess, re, concurrent.futures as cf
sys.path.insert(0, os.path.dirname(__file__))
import pgrun, llm

OUT = f'{pgrun.WORK}/state/triage'
SYSTEM = ('You classify PostgreSQL commits for a bug dataset. Answer only with JSON, no prose.')
INSTR = '''For each commit below decide:
- label: "bug" (fixes incorrect behaviour: wrong results, crash, assertion failure, error that should not happen, missing error, hang, leak, data corruption, security hole, wrong output format of an existing feature), "feature" (new capability/option/syntax), "performance" (only speed/memory improvement, behaviour unchanged), "refactor" (code cleanup, no behaviour change), or "test-build-doc" (only tests, build, docs, comments, messages wording, typos).
- symptom (for bugs): one of "crash", "assertion", "wrong-result", "spurious-error", "missing-error", "hang", "leak", "corruption", "security", "wrong-message", "other".
- subsystem: short, e.g. "planner", "executor", "parser", "plpgsql", "pg_dump", "psql", "libpq", "replication", "wal", "storage", "jsonb", "regex", "datetime", "catalog", "ecpg", "other".
- confidence: 0..1.
Return a JSON array with one object per commit: {"commit": "<first 12 chars>", "label": ..., "symptom": ..., "subsystem": ..., "confidence": ...}.
'''

def describe(c):
    msg = subprocess.run(['git', '-C', pgrun.REPO, 'log', '-1', '--format=%B', c['commit']], capture_output=True, text=True).stdout
    diff = subprocess.run(['git', '-C', pgrun.REPO, 'diff', '--stat=100', c['commit'] + '^', c['commit']], capture_output=True, text=True).stdout
    impl = subprocess.run(['git', '-C', pgrun.REPO, 'diff', '-U2', c['commit'] + '^', c['commit'], '--'] + c['impl_files'], capture_output=True, text=True, errors='replace').stdout
    return f"=== commit {c['commit'][:12]} ({c['date'][:10]})\n{msg[:2500]}\n--- diffstat\n{diff[-1500:]}\n--- implementation diff (truncated)\n{impl[:3000]}\n"

def run_batch(batch, cap):
    if llm.spent('triage') >= cap:
        return 'cap'
    prompt = INSTR + '\n' + '\n'.join(describe(c) for c in batch)
    key = ','.join(c['commit'][:12] for c in batch)
    d = llm.claude(prompt, 'haiku', 'triage', key, cwd=pgrun.WORK, max_turns=1, timeout=600,
                   extra_args=['--system-prompt', SYSTEM, '--tools', ''])
    txt = d.get('result', '')
    m = re.search(r'\[.*\]', txt, re.S)
    items = json.loads(m.group(0)) if m else []
    got = 0
    for it in items:
        for c in batch:
            if c['commit'].startswith(str(it.get('commit', 'x'))[:12]):
                it['commit'] = c['commit']; it['model'] = 'haiku'
                json.dump(it, open(f"{OUT}/{c['commit']}.json", 'w')); got += 1
    return f'{got}/{len(batch)}'

if __name__ == '__main__':
    cands, cap = sys.argv[1], float(sys.argv[2])
    bs = int(sys.argv[3]) if len(sys.argv) > 3 else 8
    lim = int(sys.argv[4]) if len(sys.argv) > 4 else 0
    os.makedirs(OUT, exist_ok=True)
    C = [json.loads(l) for l in open(cands)]
    C.sort(key=lambda c: c['date'], reverse=True)
    C = [c for c in C if not os.path.exists(f"{OUT}/{c['commit']}.json")]
    if lim: C = C[:lim]
    batches = [C[i:i + bs] for i in range(0, len(C), bs)]
    with cf.ThreadPoolExecutor(4) as ex:
        for b, r in zip(batches, ex.map(lambda b: run_batch(b, cap), batches)):
            print(b[0]['commit'][:12], r, round(llm.spent('triage'), 3), flush=True)
