#!/usr/bin/env python3
"""Measure how many candidates' implementation diffs reverse-apply on the release.

clean    = git apply --check -R succeeds (offsets allowed, no fuzz)
fuzzy    = git apply fails but GNU patch -R --dry-run -F3 succeeds
conflict = neither
Files the fix touched that no longer exist at the release count as conflict.

Usage: probe.py REPO RELEASE_WORKTREE candidates.jsonl OUT.jsonl
"""
import json, os, subprocess, sys, tempfile
from concurrent.futures import ThreadPoolExecutor


def impl_diff(repo, sha, files):
    return subprocess.run(["git", "-C", repo, "diff", "--no-renames", "--binary", f"{sha}^", sha, "--", *files],
                          check=True, capture_output=True).stdout


def probe(repo, wt, c):
    d = impl_diff(repo, c["sha"], c["impl_files"])
    with tempfile.NamedTemporaryFile(dir=os.path.expanduser("~/ts-etna-work"), suffix=".patch") as tf:
        tf.write(d); tf.flush()
        r = subprocess.run(["git", "apply", "--check", "-R", tf.name], cwd=wt, capture_output=True)
        if r.returncode == 0:
            return "clean"
        r = subprocess.run(["patch", "-R", "-p1", "--dry-run", "-F3", "-s", "-f", "-i", tf.name],
                           cwd=wt, capture_output=True)
        return "fuzzy" if r.returncode == 0 else "conflict"


def main(repo, wt, cands, out):
    cs = [json.loads(l) for l in open(cands)]
    with ThreadPoolExecutor(14) as ex:
        res = list(ex.map(lambda c: probe(repo, wt, c), cs))
    with open(out, "w") as f:
        for c, r in zip(cs, res):
            f.write(json.dumps(dict(sha=c["sha"], apply=r)) + "\n")


if __name__ == "__main__":
    main(*sys.argv[1:])
