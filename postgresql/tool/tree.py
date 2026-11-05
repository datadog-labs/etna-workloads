"""Worker trees: unconfigured export + a private git index (objects shared via alternates)
so injections can be stored as `git diff --binary` and reversal verified byte for byte."""
import os, subprocess, re
import pgrun

GIT_ID = ['-c', 'user.name=etna', '-c', 'user.email=etna@localhost']

def git(tree, *args, input=None, check=False):
    return subprocess.run(['git', *GIT_ID, '-C', tree, *args], input=input, capture_output=True, check=check)

def init_tree(rev, dest, repo=pgrun.REPO):
    pgrun.export_tree(rev, dest, repo)
    git(dest, 'init', '-q', check=True)
    with open(f'{dest}/.git/objects/info/alternates', 'w') as f:
        f.write(f'{repo}/.git/objects\n')
    tree = subprocess.run(['git', '-C', repo, 'rev-parse', f'{rev}^{{tree}}'], capture_output=True, text=True, check=True).stdout.strip()
    git(dest, 'read-tree', tree, check=True)
    git(dest, 'update-index', '-q', '--refresh')
    with open(f'{dest}/.git/etna-base-tree', 'w') as f:
        f.write(tree)
    assert is_pristine(dest), 'export does not match tree'
    return tree

def base_tree(dest):
    return open(f'{dest}/.git/etna-base-tree').read().strip()

def is_pristine(dest):
    """Tracked files equal the base tree byte for byte and no index drift."""
    git(dest, 'update-index', '-q', '--refresh')
    r1 = git(dest, 'diff', '--quiet')
    r2 = git(dest, 'diff', '--cached', '--quiet', base_tree(dest))
    return r1.returncode == 0 and r2.returncode == 0

def touched_paths(patch: bytes):
    paths = set()
    for m in re.finditer(rb'^diff --git a/(\S+) b/(\S+)', patch, re.M):
        paths.add(m.group(1).decode()); paths.add(m.group(2).decode())
    return sorted(paths)

def apply(dest, patch: bytes, allow_fuzz=True):
    """Apply a patch; return (method, stored_patch) or (None, err). Index gets the touched paths."""
    r = git(dest, 'apply', '--index', '--binary', '-', input=patch)
    method = 'exact'
    if r.returncode != 0:
        if not allow_fuzz:
            return None, r.stderr.decode(errors='replace')
        d = subprocess.run(['patch', '-p1', '--dry-run', '-F3', '-f', '-s', '--no-backup-if-mismatch'],
                           cwd=dest, input=patch, capture_output=True)
        if d.returncode != 0:
            return None, (r.stderr + d.stdout).decode(errors='replace')[:2000]
        p = subprocess.run(['patch', '-p1', '-F3', '-f', '-s', '--no-backup-if-mismatch'],
                           cwd=dest, input=patch, capture_output=True)
        if p.returncode != 0:
            restore(dest)
            return None, p.stdout.decode(errors='replace')[:2000]
        for f in touched_paths(patch):
            git(dest, 'add', '-A', '-f', '--', f)
        method = 'fuzz'
    stored = git(dest, 'diff', '--cached', '--binary', base_tree(dest)).stdout
    if not stored.strip():
        restore(dest)
        return None, 'empty after apply'
    return method, stored

def reverse(dest, stored: bytes):
    """Reverse the stored injection; True iff the tree is back to base byte for byte."""
    r = git(dest, 'apply', '-R', '--index', '--binary', '-', input=stored)
    return r.returncode == 0 and is_pristine(dest)

def restore(dest):
    """Hard reset tracked files to base (used only after failures)."""
    git(dest, 'read-tree', base_tree(dest))
    git(dest, 'checkout-index', '-a', '-f')
    # remove files not in base that the index tracked (none after read-tree), and stray patch files
    for f in subprocess.run(['git', '-C', dest, 'ls-files', '-o', '--exclude-standard'], capture_output=True, text=True).stdout.split():
        if f.endswith(('.orig', '.rej')):
            os.unlink(os.path.join(dest, f))
    return is_pristine(dest)
