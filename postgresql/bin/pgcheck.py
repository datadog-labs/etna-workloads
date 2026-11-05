#!/usr/bin/env python3
"""Check one bug in a PostgreSQL tree by reproducer and/or by its oracle tests.
usage: pgcheck.py WORKLOAD_DIR PG_DIR BUG --repro|--tests|--both"""
import json, os, re, shutil, subprocess, sys, tempfile

ANSI = re.compile(r'\x1b\[[0-9;]*[A-Za-z]')
PGR_NEW = re.compile(r'^(not ok|ok)\s+\d+\s+[-+]\s+(\S+)(.*)$')

def env(pg):
    e = {k: v for k, v in os.environ.items() if not k.startswith(('PG', 'LC_'))}
    tmp = os.path.join(pg, '.etna', 'tmp'); os.makedirs(tmp, exist_ok=True)
    e.update(TMPDIR=tmp, LANG='C.UTF-8', PG_TEST_EXTRA='ssl libpq_encryption xid_wraparound')
    return e

def sh(cmd, pg, log):
    with open(log, 'ab') as f:
        return subprocess.run(cmd, cwd=pg, env=env(pg), stdout=f, stderr=subprocess.STDOUT).returncode

def norm_name(name):
    name = re.sub(r'(?:/[\w.+-]+)+/', '<P>/', name)
    name = re.sub(r'\d{4}-\d\d-\d\d[ T]\d\d:\d\d:\d\d(?:\.\d+)?(?:[+-]\d\d(?::?\d\d)?)?', '<TS>', name)
    return re.sub(r'\b\d{5,}\b', '<N>', name)

def parse_pgr(text):
    res = {}
    for line in text.splitlines():
        m = PGR_NEW.match(ANSI.sub('', line).rstrip())
        if m:
            st, name, rest = m.groups()
            res[name] = 'skip' if ('# SKIP' in rest or '(ignored)' in rest) else ('pass' if st == 'ok' else 'fail')
    return res

def parse_tap(text, sel):
    res, seen, inside = {}, {}, False
    for raw in text.splitlines():
        line = ANSI.sub('', raw).rstrip()
        if line.startswith(sel): inside = True; continue
        if not inside or line[:1] in (' ', '\t'): continue
        m = re.match(r'^(not ok|ok)\s+(\d+)\s*(.*)$', line)
        if not m: continue
        st, num, rest = m.groups()
        dm = re.search(r'(?:^|\s)#\s*(skip|todo)\b', rest, re.I)
        name, directive = (rest[:dm.start()], dm.group(1)) if dm else (rest, '')
        name = norm_name(re.sub(r'^-\s*', '', name).strip()) or f'#{num}'
        k = seen.get(name, 0) + 1; seen[name] = k
        if k > 1: name = f'{name}#{k}'
        d = directive.lower()
        res[name] = 'skip' if d.startswith('skip') else 'todo' if d.startswith('todo') else ('pass' if st == 'ok' else 'fail')
    return res

def run_unit(pg, d, sel, log):
    cmd = (['make', '-C', d, 'check', f'PROVE_TESTS={sel}', 'PROVE_FLAGS=-v', 'REGRESS=', 'ISOLATION='] if sel
           else ['make', '-C', d, 'check', 'TAP_TESTS=', 'PROVE=true'])
    p = subprocess.run(cmd, cwd=pg, env=env(pg), capture_output=True, text=True, errors='replace')
    out = p.stdout + p.stderr
    open(log, 'a').write(out)
    return parse_tap(out, sel) if sel else parse_pgr(out)

def main():
    wl, pg, bug, mode = sys.argv[1:5]
    bd = os.path.join(wl, 'bugs', bug)
    meta = json.load(open(os.path.join(bd, 'meta.json')))
    os.makedirs(os.path.join(pg, '.etna'), exist_ok=True)
    log = os.path.join(pg, '.etna', f'check_{bug}.log'); open(log, 'w').close()
    if sh(['make', '-s', f'-j{os.cpu_count()}'], pg, log) or sh(['make', '-s', f'-j{os.cpu_count()}', '-C', 'src/test/modules'], pg, log):
        print('BUILD FAILED (see', log + ')'); sys.exit(2)
    present = False
    if mode in ('--repro', '--both'):
        r = meta.get('reproducer')
        if not r:
            print('repro: no reproducer for this bug')
        else:
            inst = os.path.join(pg, '.etna', 'inst'); shutil.rmtree(inst, ignore_errors=True)
            if sh(['make', '-s', 'install', f'DESTDIR={inst}'], pg, log):
                print('INSTALL FAILED'); sys.exit(2)
            bindir = os.path.join(inst, 'usr/local/pgsql/bin')
            out = os.path.join(pg, '.etna', 'repro.out')
            rc = subprocess.run([os.path.join(wl, 'bin', 'repro_run.sh'), bindir, os.path.join(bd, r['file']), out],
                                env=env(pg)).returncode
            got = open(out, errors='replace').read()
            exp = open(os.path.join(bd, r['expected_clean']), errors='replace').read()
            hit = got != exp or rc != r['clean_rc']
            present |= hit
            print('repro:', 'BUG PRESENT' if hit else 'CLEAN', f'(exit {rc}, clean exit {r["clean_rc"]})')
    if mode in ('--tests', '--both'):
        oracle = json.load(open(os.path.join(bd, 'oracle.json')))
        units = []
        for c in oracle['cases']:
            d, sel, _ = c.split('|', 2)
            if (d, sel) not in units: units.append((d, sel))
        failing = set(oracle['cases'])
        for rep in range(2):          # a case counts as failing only if it fails in both runs
            for d, sel in units:
                res = run_unit(pg, d, sel, log)
                for c in oracle['cases']:
                    cd, cs, n = c.split('|', 2)
                    if (cd, cs) == (d, sel) and res.get(n) == 'pass':
                        failing.discard(c)
        hit = bool(failing & set(oracle['failing']))
        present |= hit
        print('tests:', 'BUG PRESENT' if hit else 'CLEAN', f'({len(failing)} of {len(oracle["cases"])} oracle cases failing)')
        for c in sorted(failing): print('   failing:', c)
    sys.exit(1 if present else 0)

main()
