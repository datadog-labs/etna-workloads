"""Decide whether a failing oracle case is one the fix itself added.
pg_regress/isolation/ecpg: the fix created the test file, or a failing diff hunk touches
expected-output lines that `git blame REL_18_6` attributes to the fix commit.
TAP: the fix created the .pl file, or the case name occurs on a line blamed to the fix."""
import re, subprocess, functools
import pgrun

@functools.lru_cache(None)
def blamed_lines(commit, path, rev='REL_18_6'):
    r = subprocess.run(['git', '-C', pgrun.REPO, 'blame', '--line-porcelain', rev, '--', path],
                       capture_output=True, text=True, errors='replace')
    out, lines, cur = set(), {}, None
    for l in r.stdout.splitlines():
        m = re.match(r'^([0-9a-f]{40}) \d+ (\d+)', l)
        if m:
            cur = (m.group(1), int(m.group(2)))
        elif l.startswith('\t') and cur:
            if cur[0] == commit:
                out.add(cur[1]); lines[cur[1]] = l[1:]
    return out, lines

@functools.lru_cache(None)
def added_files(commit):
    r = subprocess.run(['git', '-C', pgrun.REPO, 'diff', '--name-status', '--no-renames', commit + '^', commit],
                       capture_output=True, text=True)
    return {l.split('\t', 1)[1] for l in r.stdout.splitlines() if l.startswith('A\t')}

def diff_sections(text):
    """Yield (expected_path_abs, [hunk lines]) for each file in a pg_regress diff."""
    cur, buf = None, []
    for l in text.splitlines():
        m = re.match(r'^diff (?:-\S+ )*(\S+) (\S+)$', l)
        if m:
            if cur: yield cur, buf
            cur, buf = m.group(1), []
        elif cur:
            buf.append(l)
    if cur: yield cur, buf

def touched_old_lines(hunk_lines):
    touched, old = set(), None
    for l in hunk_lines:
        m = re.match(r'^@@ -(\d+)(?:,(\d+))? \+\d+(?:,\d+)? @@', l)
        if m:
            old = int(m.group(1)) - (0 if m.group(2) != '0' else -1); continue
        if old is None or l.startswith(('---', '+++')):
            continue
        if l.startswith('-'):
            touched.add(old); old += 1
        elif l.startswith('+'):
            touched.update((old - 1, old))
        else:
            old += 1
    return touched

def classify(commit, case, runs, tree_prefix):
    """Return 'file-added' | 'lines-added' | 'name-added' | None."""
    d, sel, name = case.split('|', 2)
    added = added_files(commit)
    if sel:                                              # TAP
        path = f'{d}/{sel}'
        if path in added: return 'file-added'
        _, lines = blamed_lines(commit, path)
        base = re.sub(r'#\d+$', '', name)
        parts = [base] + [p for p in re.split(r': |<P>|<N>|<TS>', base) if len(p.strip()) >= 12]
        for p in parts:
            if len(p) >= 6 and any(p in l for l in lines.values()): return 'name-added'
        return None
    # pg_regress style: look for test file created by the fix
    for f in added:
        if f.startswith(d + '/') and re.search(rf'/(sql|specs|expected)/{re.escape(name.split("/")[-1])}(_\d+)?\.', f):
            return 'file-added'
    for r in runs:
        for _, text in (r.get('diffs') or {}).items():
            for exp, hl in diff_sections(text):
                i = exp.find('/src/')
                rel = exp[i + 1:] if i >= 0 else re.sub(r'^(\.\./)+', '', exp)
                stem = rel.rsplit('/', 1)[-1]
                want = name.replace('/', '-')
                if not re.match(rf'^{re.escape(want)}(_\d+)?\.(out|stdout|stderr|c)$', stem):
                    continue
                if not rel.startswith('src/'):
                    rel = f'{d}/{rel}'
                bl, _ = blamed_lines(commit, rel)
                if bl & touched_old_lines(hl):
                    return 'lines-added'
    return None
