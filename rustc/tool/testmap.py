#!/usr/bin/env python3
"""Map each candidate's test changes to compiletest case files at the release.

A fix may touch the test file itself, its expectation files (.stderr, .stdout,
.fixed, mir-opt .diff/.mir dumps) or auxiliary files.  Each touched file is
mapped to the owning test `.rs` at the fix commit, then followed through later
renames up to the release.  Output: data/testmap.jsonl.
"""
import json
import os
import re
import sys
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, ORACLE_SUITES, RELEASE, WORK, git, test_suite  # noqa: E402

PREFIX_RULES = [("src/test/", "tests/"), ("tests/codegen/", "tests/codegen-llvm/"),
                ("tests/assembly/", "tests/assembly-llvm/"), ("tests/rustdoc/", "tests/rustdoc-html/")]


def load_renames():
    """[(time, old, new)] ascending by commit time."""
    out = []
    t = None
    for line in open(os.path.join(WORK, "test-renames.txt")):
        if line.startswith("C "):
            t = int(line.split()[2])
        elif line.startswith("R"):
            parts = line.rstrip("\n").split("\t")
            if len(parts) == 3:
                out.append((t, parts[1], parts[2]))
    out.sort()
    return out


RENAMES = {}
for _t, _old, _new in load_renames():
    RENAMES.setdefault(_old, []).append((_t, _new))
RELEASE_TESTS = set(git("ls-tree", "-r", "--name-only", RELEASE, "tests").split("\n"))


def chase(p, t):
    """Apply the chain of renames of p that happened after time t."""
    for _ in range(50):
        nxt = [(tt, new) for tt, new in RENAMES.get(p, ()) if tt >= t]
        if not nxt:
            break
        t, p = min(nxt)
    return p


def follow(path, t0):
    """Follow renames after time t0, then prefix rules for mass moves."""
    p = chase(path, t0)
    for a, b in PREFIX_RULES:
        if p.startswith(a) and p not in RELEASE_TESTS:
            p = chase(b + p[len(a):], t0)
    return p if p in RELEASE_TESTS else None


def owning_test(path, tree):
    """Map a touched file under a suite dir to its test case file (or None)."""
    parts = path.split("/")
    if "auxiliary" in parts:
        return None
    if path.endswith(".rs"):
        return path
    d, name = path.rsplit("/", 1)
    pieces = name.split(".")
    for k in range(len(pieces) - 1, 0, -1):
        cand = f"{d}/{'.'.join(pieces[:k])}.rs"
        if cand in tree:
            return cand
    return None


def map_candidate(c):
    h = c["commit"]
    t0 = int(git("log", "-1", "--format=%ct", h).strip())
    st = git("diff", "-M", "--name-status", f"{h}^", h, "--", "tests", "src/test")
    files_after = set()
    status = {}
    for line in st.splitlines():
        parts = line.split("\t")
        s = parts[0][0]
        if s == "R":
            old, new = parts[1], parts[2]
            # crashes -> ui (or any move out of crashes) counts as adding the test
            status[new] = "A" if "/crashes/" in old and "/crashes/" not in new else "R"
            files_after.add(new)
        elif s in "AM":
            status[parts[1]] = s
            files_after.add(parts[1])
        elif s == "D":
            status[parts[1]] = "D"
    # .rs files at C in the touched directories (to resolve expectation owners).
    dirs = sorted({p.rsplit("/", 1)[0] for p in files_after})
    tree = set()
    if dirs:
        tree = {x for x in git("ls-tree", "--name-only", h, "--", *[d + "/" for d in dirs]).split()
                if x.endswith(".rs")}
    cases = {}
    for p in sorted(files_after):
        suite = test_suite(p)
        if not suite:
            continue
        owner = owning_test(p, tree | {p})
        if owner is None:
            continue
        e = cases.setdefault(owner, dict(fix_path=owner, suite=test_suite(owner),
                                          added=False, touched=[]))
        e["touched"].append(p)
        if p == owner and status.get(p) == "A":
            e["added"] = True
    out = []
    for owner, e in cases.items():
        e["release_path"] = follow(owner, t0)
        e["oracle_suite"] = test_suite(e["release_path"] or owner) in ORACLE_SUITES
        out.append(e)
    return dict(commit=h, cases=out)


def main():
    cands = [json.loads(line) for line in open(os.path.join(DATA, "candidates.jsonl"))]
    with ThreadPoolExecutor(16) as ex:
        res = list(ex.map(map_candidate, cands))
    with open(os.path.join(DATA, "testmap.jsonl"), "w") as f:
        for r in res:
            f.write(json.dumps(r) + "\n")
    n_cases = sum(len(r["cases"]) for r in res)
    mapped = sum(1 for r in res for e in r["cases"] if e["release_path"] and e["oracle_suite"])
    added = sum(1 for r in res for e in r["cases"] if e["release_path"] and e["oracle_suite"] and e["added"])
    with_any = sum(1 for r in res if any(e["release_path"] and e["oracle_suite"] for e in r["cases"]))
    print(f"cases {n_cases}, mapped to release oracle suites {mapped} (added-by-fix {added}); "
          f"candidates with >=1 mapped case {with_any}/{len(res)}")


if __name__ == "__main__":
    main()
