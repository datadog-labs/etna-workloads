"""Build PostgreSQL trees and run test units; parse runner output into per-case results."""
import os, re, subprocess, shutil, time, json

WORK = os.environ.get('ETNA_WORK', os.path.expanduser('~/pg-etna-work'))
REPO = f'{WORK}/pg'
CONFIGURE = ['--enable-cassert', '--enable-debug', '--enable-depend', '--enable-injection-points', '--enable-tap-tests',
             '--with-python', '--with-tcl', '--with-libxml', '--with-libxslt',
             '--with-lz4', '--with-icu', '--with-openssl', '--with-uuid=e2fs']
ANSI = re.compile(r'\x1b\[[0-9;]*[A-Za-z]')

def env_for(tree):
    e = {k: v for k, v in os.environ.items() if not k.startswith(('PG', 'LC_'))}
    portdir = os.environ.get('ETNA_PORT_DIR', f'{WORK}/portlock')
    tmp = f'{tree}/.tmp'
    os.makedirs(tmp, exist_ok=True)
    e.update(TMPDIR=tmp, LANG='C.UTF-8', PYTHON='/usr/bin/python3',
             PG_TEST_PORT_DIR=portdir, PG_TEST_EXTRA='ssl libpq_encryption xid_wraparound',
             PATH='/usr/bin:/bin:/usr/local/bin')
    os.makedirs(e['PG_TEST_PORT_DIR'], exist_ok=True)
    return e

def kill_tree_procs(tree):
    """Kill leftover processes whose executable lives in this tree (e.g. orphaned postmasters)."""
    import signal
    tree = os.path.realpath(tree) + '/'
    for pid in os.listdir('/proc'):
        if not pid.isdigit() or int(pid) == os.getpid():
            continue
        try:
            exe = os.readlink(f'/proc/{pid}/exe')
        except OSError:
            continue
        if exe.startswith(tree):
            try: os.kill(int(pid), signal.SIGKILL)
            except OSError: pass

MEM_LIMIT = 6 << 30      # per-process address-space cap: an injected runaway allocation must not take the host down

def _limits():
    import resource
    resource.setrlimit(resource.RLIMIT_AS, (MEM_LIMIT, MEM_LIMIT))

def sh(cmd, cwd, env, log, timeout):
    import signal
    with open(log, 'ab') as f:
        f.write(f'\n$ {cmd if isinstance(cmd, str) else " ".join(cmd)}\n'.encode()); f.flush()
        p = subprocess.Popen(cmd, cwd=cwd, env=env, stdout=f, stderr=subprocess.STDOUT,
                             shell=isinstance(cmd, str), start_new_session=True, preexec_fn=_limits)
        try:
            return p.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            try: os.killpg(p.pid, signal.SIGKILL)
            except OSError: pass
            p.wait()
            f.write(b'\n### TIMEOUT\n')
            return 'timeout'

def export_tree(rev, dest, repo=REPO):
    """Unconfigured source export (never copy a configured tree)."""
    os.makedirs(dest)
    subprocess.run(f'git -C {repo} archive {rev} | tar -x -C {dest}', shell=True, check=True)

def configure(tree, log, extra=()):
    return sh(['./configure', '--silent', *CONFIGURE, *extra], tree, env_for(tree), log, 1800)

def build(tree, log, jobs=8):
    e = env_for(tree)
    rc = sh(['make', '-s', f'-j{jobs}'], tree, e, log, 3600)
    if rc != 0:
        return rc
    # test modules are built by their own `make check`; build them up front to surface errors
    return sh(['make', '-s', f'-j{jobs}', '-C', 'src/test/modules'], tree, e, log, 1800)

def unit_cmd(unit):
    kind, d, sel = unit
    if kind == 'tap':
        return ['make', '-C', d, 'check', f'PROVE_TESTS={sel}', 'PROVE_FLAGS=-v',
                'REGRESS=', 'ISOLATION=']
    return ['make', '-C', d, 'check', 'TAP_TESTS=', 'PROVE=true']

PGR_LINE = re.compile(r'^(not ok|ok)\s+\d+\s+[-+]\s+(\S+)(.*)$')
# pre-16 pg_regress: "test foo ... ok 12 ms", "     foo ... FAILED", "foo ... failed (ignored)"
PGR_OLD = re.compile(r'^(?:test\s+|\s+)?(\S+)\s+\.\.\.\s+(ok|FAILED|failed \(ignored\)|failed)(?=\s|$)')
TAP_LINE = re.compile(r'^\s*(not ok|ok)\s+(\d+)(?:\s+-?\s*(.*?))?\s*$')

def parse_pgr(text):
    res = {}
    for line in text.splitlines():
        line = ANSI.sub('', line).rstrip()
        mo = PGR_OLD.match(line)
        if mo and not line.startswith('ok'):
            res[mo.group(1)] = {'ok': 'pass', 'FAILED': 'fail', 'failed': 'fail'}.get(mo.group(2), 'skip')
            continue
        m = PGR_LINE.match(line)
        if m:
            st, name, rest = m.groups()
            if '# SKIP' in rest or '(ignored)' in rest:
                st = 'skip'
            res[name] = 'pass' if st == 'ok' else ('skip' if st == 'skip' else 'fail')
    return res

def norm_name(name):
    """Remove run-specific parts of TAP test names: directories, timestamps, pids/seeds."""
    name = re.sub(r'(?:/[\w.+-]+)+/', '<P>/', name)
    name = re.sub(r'\d{4}-\d\d-\d\d[ T]\d\d:\d\d:\d\d(?:\.\d+)?(?:[+-]\d\d(?::?\d\d)?)?', '<TS>', name)
    return re.sub(r'\b\d{5,}\b', '<N>', name)

def parse_tap(text, sel):
    """Parse `prove -v` output of one file. Names deduplicated with #k; unnamed -> #<num>."""
    res, seen, inside = {}, {}, False
    for raw in text.splitlines():
        line = ANSI.sub('', raw).rstrip()
        if line.startswith(sel):
            inside = True
            continue
        if not inside or line[:1] in (' ', '\t'):
            continue                       # before the file header, or subtest internals
        m = re.match(r'^(not ok|ok)\s+(\d+)\s*(.*)$', line)
        if not m:
            continue
        st, num, rest = m.groups()
        dm = re.search(r'(?:^|\s)#\s*(skip|todo)\b', rest, re.I)
        name, directive = (rest[:dm.start()], dm.group(1)) if dm else (rest, '')
        name = norm_name(re.sub(r'^-\s*', '', name).strip()) or f'#{num}'
        k = seen.get(name, 0) + 1; seen[name] = k
        if k > 1:
            name = f'{name}#{k}'
        d = directive.lower()
        res[name] = ('skip' if d.startswith('skip') else 'todo' if d.startswith('todo')
                     else 'pass' if st == 'ok' else 'fail')
    return res

def collect_diffs(tree, d):
    """pg_regress diff files produced in a unit dir (regress, isolation, ecpg variants)."""
    out = {}
    for sub in ('', 'output_iso', 'results', 'test'):
        p = os.path.join(tree, d, sub, 'regression.diffs')
        if os.path.exists(p):
            out[os.path.join(d, sub)] = open(p, errors='replace').read()[:400000]
    return out

def run_unit(tree, unit, log, timeout=1800):
    """Run one unit; return dict(status, cases{name:pass|fail|skip}, rc, secs, diffs)."""
    t0 = time.time()
    for sub in ('', 'output_iso', 'results', 'test'):
        p = os.path.join(tree, unit[1], sub, 'regression.diffs')
        if os.path.exists(p): os.unlink(p)
    out_log = log + '.out'
    if os.path.exists(out_log): os.unlink(out_log)
    rc = sh(unit_cmd(unit), tree, env_for(tree), out_log, timeout)
    kill_tree_procs(tree)
    text = open(out_log, errors='replace').read()
    with open(log, 'a') as f: f.write(text)
    cases = parse_tap(text, unit[2]) if unit[0] == 'tap' else parse_pgr(text)
    return dict(rc=rc, secs=round(time.time() - t0, 1), cases=cases,
                diffs=collect_diffs(tree, unit[1]) if unit[0] == 'pgr' else {},
                tail=text[-3000:])
