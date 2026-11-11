#!/usr/bin/env python3
"""For each candidate, check whether the reversed impl diff applies to RELEASE: clean / fuzzy / conflict."""
import json, os, sys, subprocess, tempfile, collections
sys.path.insert(0, os.path.dirname(__file__))
from common import *

def impl_diff(sha, impl):
    return git("diff", "--binary", f"{sha}^", sha, "--", *impl)

def classify(sha, impl, tree):
    d = impl_diff(sha, impl)
    if not d.strip(): return "empty"
    r = subprocess.run(["git", "apply", "-R", "--check"], cwd=tree, input=d, text=True, capture_output=True)
    if r.returncode == 0: return "clean"
    r = subprocess.run(["git", "apply", "-R", "--check", "-C1"], cwd=tree, input=d, text=True, capture_output=True)
    if r.returncode == 0: return "fuzzy"
    r = subprocess.run(["patch", "-R", "-p1", "--dry-run", "-F3", "-s", "-f"], cwd=tree, input=d, text=True, capture_output=True)
    if r.returncode == 0: return "fuzzy"
    return "conflict"

def main():
    cands = json.load(open(os.path.join(DATA, "candidates.json")))
    tree = os.path.join(WORK, "base", "src")
    if not os.path.isdir(tree):
        os.makedirs(tree)
        subprocess.run(f"git -C {REPO} archive {RELEASE} | tar -x -C {tree}", shell=True, check=True)
    for c in cands:
        c["apply"] = classify(c["sha"], c["impl"], tree)
    json.dump(cands, open(os.path.join(DATA, "candidates.json"), "w"), indent=1)
    print(collections.Counter(c["apply"] for c in cands))

if __name__ == "__main__":
    main()
