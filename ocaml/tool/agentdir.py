"""Prepare agent work directories: real (writable) copies of the release source,
configured and built in place at the agent's own path (never hard links)."""
import os, shutil, subprocess
from pathlib import Path
from common import *
from slots import RELEASE_SRC, CONFIGURE_FLAGS, sh, JOBS

AGENTS = WORK / "agents"


def fresh_tree(dst, prefix, log, jobs=None):
    """Copy the release source to dst, configure with prefix, build. -> bool"""
    if dst.exists():
        subprocess.run(["chmod", "-R", "u+w", str(dst)])
        shutil.rmtree(dst)
    shutil.copytree(RELEASE_SRC, dst, symlinks=True)
    subprocess.run(["chmod", "-R", "u+w", str(dst)], check=True)
    if sh(["./configure", *CONFIGURE_FLAGS, f"--prefix={prefix}"], dst, log) != 0:
        return False
    j = str(jobs or JOBS)
    if sh(["make", f"-j{j}"], dst, log, timeout=3600) != 0:
        return False
    return sh(["make", f"-j{j}", "ocamltest"], dst, log, timeout=1800) == 0


def tracked_files():
    return [l for l in git("ls-tree", "-r", "--name-only", RELEASE).splitlines()]


def changed_tracked(tree):
    """Tracked release files whose content differs in tree (ignores symlinked paths)."""
    out = []
    for p in tracked_files():
        a, b = RELEASE_SRC / p, Path(tree) / p
        # ignore anything reached through a symlinked file or directory
        cur, sym = Path(tree), False
        for part in Path(p).parts:
            cur = cur / part
            if cur.is_symlink():
                sym = True
                break
        if sym or a.is_symlink():
            continue
        if not b.exists():
            out.append(p)
        elif a.is_file() and a.read_bytes() != b.read_bytes():
            out.append(p)
    return out


def run_oracle_script(tree, units):
    """Shell script the agent uses to run the oracle units on its tree.
    Every run is appended to <workdir>/oracle-runs.log (harness-side evidence)."""
    log = Path(tree).parent / "oracle-runs.log"
    lines = ["#!/bin/sh", "# Runs the oracle tests on this tree. Rebuild first.",
             f'cd "{tree}/testsuite" || exit 2',
             'export SORT=sort MAKE=make TERM=dumb USE_RUNTIME=d OCAMLRUNPARAM=v=0',
             f'LOG="{log}"', 'echo "=== $(date +%s) run-oracle" >> "$LOG"', 'rc=0']
    for u in units:
        lines.append(f'd=$(mktemp -d "$TMPDIR/ot.XXXXXX"); OCAMLTESTDIR=$d ../ocamltest/ocamltest -timeout 300 {u} '
                     f'> "$d.out" 2>&1 || rc=1; cat "$d.out"; grep "^ ... testing" "$d.out" >> "$LOG"; '
                     f'grep -q "^ ... testing [^ ]* => passed" "$d.out" || rc=1; rm -rf "$d" "$d.out"')
    lines.append('echo "rc=$rc" >> "$LOG"')
    lines.append('exit $rc')
    return "\n".join(lines) + "\n"
