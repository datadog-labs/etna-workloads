#!/usr/bin/env python3
"""Anchor for adapted bugs: at the fix commit C, run the oracle units on C (twice) and on C with
the fix's implementation reversed (twice). anchor_failing = cases passing on C and failing with the
reversal. 'exact' iff anchor_failing shares a case with the adapted injection's failing cases.
usage: anchor.py [--parallel N] [--only c1,c2]"""
import json, os, re, sys, glob, shutil, subprocess, argparse, concurrent.futures as cf, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import pgrun, tree
from oracle import candidate_units, ukey
from units import case_id

W = pgrun.WORK
OUT = f'{W}/state/anchor'
COMPAT_CFLAGS = '-O2 -g -fcommon -std=gnu99 -Wno-error -fno-strict-aliasing -fwrapv'

def supported_flags(t):
    help_ = subprocess.run(['./configure', '--help'], cwd=t, capture_output=True, text=True).stdout
    out = []
    for f in pgrun.CONFIGURE:
        opt = f.split('=')[0]
        if opt in help_:
            out.append(f)
    return out

def compat_edits(t):
    """Build-compatibility renames for old trees vs. new glibc; behaviour-neutral, recorded in results."""
    done = []
    d = f'{t}/src/bin/pg_rewind'
    if os.path.isdir(d):
        files = [f for f in glob.glob(f'{d}/*.[ch]') if 'copy_file_range' in open(f, errors='replace').read()]
        if any(re.search(r'^\s*(void|static void)?\s*\n?copy_file_range\s*\(', open(f, errors='replace').read(), re.M) for f in files):
            for f in files:
                txt = open(f, errors='replace').read()
                open(f, 'w').write(re.sub(r'\bcopy_file_range\b', 'rewind_copy_file_range', txt))
                done.append(os.path.relpath(f, t))
    return done

def flex_wrapper(t):
    """Old configure scripts misparse flex 2.6.x as older than 2.5.31; report a compatible
    version string to configure and run the real flex for everything else."""
    if 'Flex version 2.5.31 or later is required' not in open(f'{t}/configure', errors='replace').read():
        return None
    d = f'{t}/.etna-compat'; os.makedirs(d, exist_ok=True)
    w = f'{d}/flex'
    open(w, 'w').write('#!/bin/sh\n[ "$1" = "--version" ] && { echo "flex 2.5.39"; exit 0; }\nexec /usr/bin/flex "$@"\n')
    os.chmod(w, 0o755)
    return w

def build_old(t, log, need_python=False):
    flags = supported_flags(t)
    fw = flex_wrapper(t)
    extra = [f'FLEX={fw}'] if fw else []
    tries = [(flags, None), (flags, COMPAT_CFLAGS)]
    h = f'{t}/src/pl/plpython/plpython.h'
    old_py = os.path.exists(h) and re.search(r'#include\s*[<"]eval\.h[>"]', open(h, errors='replace').read())
    if old_py and not need_python:
        tries = []                                   # cannot build with this Python; skip straight to no-python
    if not need_python:
        # PL/Python before 2022 includes <eval.h>, removed in Python 3.11: build without it
        nopy = [f for f in flags if f != '--with-python']
        tries += [(nopy, None), (nopy, COMPAT_CFLAGS)]
    # last resort for old trees vs new system libraries (e.g. ICU >= 68 dropped TRUE/FALSE):
    # core options only; cases needing a dropped library must still pass at the fix commit to count
    core = [f for f in flags if f.startswith('--enable-')] + (['--with-python'] if need_python else [])
    tries += [(core, COMPAT_CFLAGS)]
    for attempt, (flags, cflags) in enumerate(tries):
        if attempt:
            subprocess.run(['make', '-s', 'distclean'], cwd=t, capture_output=True)
        cmd = ['./configure', '--silent', *flags, *extra] + ([f'CFLAGS={cflags}'] if cflags else [])
        if pgrun.sh(cmd, t, pgrun.env_for(t), log, 1800) != 0:
            continue
        if pgrun.build(t, log, 4) == 0:
            return dict(ok=True, flags=flags, cflags=cflags, flex_wrapper=bool(fw))
    return dict(ok=False, flags=flags)

def files_at(rev):
    return frozenset(subprocess.run(['git', '-C', pgrun.REPO, 'ls-tree', '-r', '--name-only', rev],
                                    capture_output=True, text=True).stdout.split())

def run_units(t, units, log, reps=2):
    """{case_id: [status per rep]} for all cases of the given units (restricted by names)."""
    res = collections.defaultdict(list)
    for rep in range(reps):
        for u, names in units.items():
            r = pgrun.run_unit(t, u, log, timeout=1800)
            seen = r['cases']
            want = seen.keys() if names is None else names
            for n in want:
                res[case_id(u, n)].append(seen.get(n, 'missing'))
    return res

def anchor(c, adapted_failing):
    short = c['commit'][:12]
    t = f'{W}/anchor/{short}'
    log = f'{W}/logs/anchor/{short}.log'
    os.makedirs(os.path.dirname(log), exist_ok=True)
    if os.path.exists(log): os.unlink(log)
    shutil.rmtree(t, ignore_errors=True)
    res = dict(commit=c['commit'])
    try:
        tree.init_tree(c['commit'], t)
        units = candidate_units(c['test_files'], files_at(c['commit']))
        if not units:
            res['status'] = 'no_units_at_fix'; return res
        res['compat_edits'] = compat_edits(t)
        b = build_old(t, log, need_python=any('plpython' in u[1] for u in units))
        res['build'] = b
        if not b['ok']:
            res['status'] = 'build_fails'; return res
        base = run_units(t, units, log)
        passing = {k for k, v in base.items() if v and all(x == 'pass' for x in v)}
        patch = subprocess.run(['git', '-C', pgrun.REPO, 'diff', '--binary', '--no-renames', c['commit'], c['commit'] + '^', '--']
                               + c['impl_files'], capture_output=True).stdout
        method, stored = tree.apply(t, patch, allow_fuzz=False)
        if method is None:
            res['status'] = 'reverse_does_not_apply'; return res
        if pgrun.build(t, log, 4) != 0:
            res['status'] = 'build_fails_reversed'; return res
        inj = run_units(t, units, log)
        failing = sorted(k for k in passing if inj.get(k) and all(x in ('fail', 'missing') for x in inj[k]))
        common = sorted(set(failing) & set(adapted_failing))
        res.update(passing_at_fix=len(passing), anchor_failing=failing, common=common,
                   status='exact' if common else ('fails_other_cases' if failing else 'no_failure'))
        return res
    except Exception as e:
        res.update(status='harness_error', why=repr(e)); return res
    finally:
        pgrun.kill_tree_procs(t)
        shutil.rmtree(t, ignore_errors=True)

def main():
    ap = argparse.ArgumentParser(); ap.add_argument('--parallel', type=int, default=2); ap.add_argument('--only', default='')
    ap.add_argument('--need-fix-added', action='store_true', help='skip bugs with no fix-added failing case (cannot be strict)')
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    C = {json.loads(l)['commit']: json.loads(l) for l in open(f'{W}/candidates.jsonl')}
    todo = []
    for p in glob.glob(f'{W}/state/adapted/*.json'):
        r = json.load(open(p))
        if r.get('status') != 'gate_pass' or os.path.exists(f'{OUT}/{r["commit"]}.json'):
            continue
        if a.only and not any(r['commit'].startswith(x) for x in a.only.split(',')):
            continue
        if a.need_fix_added:
            import fixadded
            if not any(fixadded.classify(r['commit'], c, r.get('runs', []), '') for c in r['failing']):
                continue
        todo.append((C[r['commit']], r['failing']))
    todo.sort(key=lambda x: x[0]['date'], reverse=True)
    def one(x):
        r = anchor(*x)
        json.dump(r, open(f'{OUT}/{x[0]["commit"]}.json', 'w'))
        return x[0]['commit'][:12], r['status'], len(r.get('anchor_failing', [])), len(r.get('common', []))
    with cf.ThreadPoolExecutor(a.parallel) as ex:
        for r in ex.map(one, todo):
            print(*r, flush=True)

if __name__ == '__main__':
    main()
