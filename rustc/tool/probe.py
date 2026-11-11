#!/usr/bin/env python3
"""Probe: does each candidate's reversed implementation diff apply to the release?

Writes data/probe.jsonl with apply status: clean | fuzzy | partial | conflict.
"""
import json
import os
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, REPO, WORK, git  # noqa: E402

TREE = os.path.join(WORK, "probe-1.99.1")
TMP = os.path.join(WORK, "tmp")


def impl_diff(c):
    return git("diff", "--no-renames", "--full-index", "--binary",
               f"{c['commit']}^", c["commit"], "--", *c["impl_files"])


def try_apply(patch_path, *extra):
    r = subprocess.run(["git", "apply", "--check", "-R", *extra, patch_path],
                       cwd=TREE, capture_output=True)
    return r.returncode == 0


def try_patch(patch_path):
    r = subprocess.run(["patch", "-R", "-p1", "--dry-run", "-F3", "-f", "-s", "-i", patch_path],
                       cwd=TREE, capture_output=True, text=True)
    out = r.stdout + r.stderr
    failed = out.count("FAILED")
    return r.returncode == 0, failed


def hunks(patch):
    return sum(1 for line in patch.splitlines() if line.startswith("@@"))


def test_presence(c):
    """How many of the fix's added test files still exist at the release."""
    added = [p for p in c["tests_added"] if not p.endswith((".stderr", ".stdout", ".fixed"))]
    present = 0
    for p in added:
        q = p.replace("src/test/", "tests/", 1)
        if os.path.exists(os.path.join(TREE, q)):
            present += 1
        elif q.startswith("tests/crashes/"):
            pass
    return len(added), present


def probe(c):
    patch = impl_diff(c)
    os.makedirs(TMP, exist_ok=True)
    with tempfile.NamedTemporaryFile("w", dir=TMP, suffix=".patch", delete=False) as f:
        f.write(patch)
        path = f.name
    try:
        n = hunks(patch)
        if not patch.strip():
            status, failed = "empty", 0
        elif try_apply(path):
            status, failed = "clean", 0
        elif try_apply(path, "-C1"):
            status, failed = "fuzzy", 0
        else:
            ok, failed = try_patch(path)
            if ok:
                status = "fuzzy"
            elif failed < n:
                status = "partial"
            else:
                status = "conflict"
        added, present = test_presence(c)
        return dict(commit=c["commit"], status=status, hunks=n, failed_hunks=failed,
                    patch_lines=patch.count("\n"), tests_added=added, tests_present=present)
    finally:
        os.unlink(path)


def main():
    cands = [json.loads(line) for line in open(os.path.join(DATA, "candidates.jsonl"))]
    with ThreadPoolExecutor(16) as ex:
        res = list(ex.map(probe, cands))
    with open(os.path.join(DATA, "probe.jsonl"), "w") as f:
        for r in res:
            f.write(json.dumps(r) + "\n")
    from collections import Counter
    print(Counter(r["status"] for r in res))


if __name__ == "__main__":
    _ = REPO
    main()
