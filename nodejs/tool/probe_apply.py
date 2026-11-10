#!/usr/bin/env python3
"""Measure how many candidates' implementation diffs reverse-apply on the release.

clean    : `git apply -R --check` succeeds (offsets allowed, no fuzz)
fuzzy    : git apply fails, GNU `patch -R --dry-run -N -F2` succeeds
conflict : neither
Adds an "apply" field to each candidate and writes a new JSONL.
"""
import argparse, json, subprocess, sys
from concurrent.futures import ThreadPoolExecutor


def impl_diff(repo, c):
    return subprocess.run(["git", "-C", repo, "diff", "--binary", f"{c['sha']}^", c["sha"],
                           "--", *c["impl_files"]], capture_output=True, check=True).stdout


def check(repo, tree, c):
    d = impl_diff(repo, c)
    if not d.strip():
        return "empty"
    r = subprocess.run(["git", "apply", "-R", "--check", "-"], cwd=tree, input=d, capture_output=True)
    if r.returncode == 0:
        return "clean"
    r = subprocess.run(["patch", "-R", "-p1", "--dry-run", "-N", "-s", "-F2"], cwd=tree,
                       input=d, capture_output=True)
    return "fuzzy" if r.returncode == 0 else "conflict"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", required=True)
    ap.add_argument("--tree", required=True, help="checkout of the release")
    ap.add_argument("--inp", required=True)
    ap.add_argument("--out", required=True)
    a = ap.parse_args()
    cands = [json.loads(l) for l in open(a.inp)]
    with ThreadPoolExecutor(16) as ex:
        res = list(ex.map(lambda c: check(a.repo, a.tree, c), cands))
    with open(a.out, "w") as f:
        for c, r in zip(cands, res):
            c["apply"] = r
            f.write(json.dumps(c) + "\n")
    from collections import Counter
    print(Counter(res), file=sys.stderr)


if __name__ == "__main__":
    main()
