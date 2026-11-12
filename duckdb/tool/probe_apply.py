"""Classify how each candidate's reversed implementation diff applies to the release tree.

clean    : git apply -R --check succeeds
fuzzy    : git apply fails, GNU patch -R (fuzz<=2, offsets) succeeds in dry run
conflict : neither
Writes probe.jsonl (sha -> status) next to the candidates.
"""
import json, subprocess, sys, os
from concurrent.futures import ThreadPoolExecutor

REPO, TREE, CANDS, OUT = sys.argv[1:5]


def impl_diff(c):
    return subprocess.run(["git", "-C", REPO, "diff", "--no-renames", "--binary", c["parent"], c["sha"], "--", "src/"],
                          capture_output=True, check=True).stdout


def classify(c):
    d = impl_diff(c)
    if not d.strip():
        return "empty"
    if subprocess.run(["git", "-C", TREE, "apply", "-R", "--check", "-"], input=d, capture_output=True).returncode == 0:
        return "clean"
    r = subprocess.run(["patch", "-d", TREE, "-p1", "-R", "--dry-run", "--batch", "-F2", "-s"],
                       input=d, capture_output=True)
    return "fuzzy" if r.returncode == 0 else "conflict"


cands = [json.loads(l) for l in open(CANDS)]
with ThreadPoolExecutor(16) as ex, open(OUT, "w") as f:
    for c, s in zip(cands, ex.map(classify, cands)):
        f.write(json.dumps({"sha": c["sha"], "apply": s}) + "\n")
