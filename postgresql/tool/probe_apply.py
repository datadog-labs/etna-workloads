#!/usr/bin/env python3
"""Classify reversed implementation diffs against the release tree: clean / fuzzy / conflict."""
import json, subprocess, sys, os, concurrent.futures as cf
REPO, TREE, CANDS = sys.argv[1:4]

def impl_diff(c):
    return subprocess.run(['git', '-C', REPO, 'diff', '--binary', '--no-renames', c['commit'] + '^', c['commit'], '--'] + c['impl_files'],
                          capture_output=True).stdout

def classify(c):
    d = impl_diff(c)
    if not d.strip():
        return c['commit'], 'empty', ''
    r = subprocess.run(['git', 'apply', '-R', '--check', '-'], input=d, cwd=TREE, capture_output=True)
    if r.returncode == 0:
        return c['commit'], 'clean', ''
    r2 = subprocess.run(['patch', '-R', '-p1', '--dry-run', '-F3', '-f', '-s'], input=d, cwd=TREE, capture_output=True)
    out = r2.stdout.decode(errors='replace')
    if r2.returncode == 0 and 'FAILED' not in out and 'Reversed' not in out:
        return c['commit'], 'fuzzy', ''
    return c['commit'], 'conflict', (r.stderr.decode(errors='replace').splitlines() or [''])[0][:200]

C = [json.loads(l) for l in open(CANDS)]
with cf.ThreadPoolExecutor(16) as ex:
    for h, cls, why in ex.map(classify, C):
        print(json.dumps(dict(commit=h, apply=cls, why=why)))
