"""Map each candidate's test files to ocamltest units (test files) present in the release.

unit = path relative to testsuite/, e.g. tests/basic/patmatch.ml
Mapping of a fix test file F (testsuite/tests/D/...):
  * F itself is a test unit                -> F
  * otherwise (reference/aux file)         -> units in D (or nearest ancestor with
                                              tests) whose name stem equals F's stem;
                                              if none, all units of that directory (cap 40)
"""
import os, subprocess
from collections import defaultdict
from common import *
from slots import Slot


def all_units():
    cached = load("release_units.json")
    if cached:
        return cached
    s = Slot(0)
    ts = s.src / "testsuite"
    env = dict(os.environ, SORT="sort", MAKE="make")
    ot = "../ocamltest/ocamltest"
    dirs = subprocess.run([ot, "-find-test-dirs", "tests"], cwd=ts, env=env,
                          capture_output=True, text=True, check=True).stdout.split()
    units = {}
    for d in dirs:
        fs = subprocess.run([ot, "-list-tests", d], cwd=ts, env=env,
                            capture_output=True, text=True, check=True).stdout.split()
        units[d] = sorted(fs)
    save("release_units.json", units)
    return units


def stem(name):
    return name.split(".")[0]


def map_candidate(c, units, unitset):
    out, how = [], {}
    for f in c["test_files"]:
        if not f.startswith("testsuite/tests/"):
            continue
        rel = f[len("testsuite/"):]
        if rel in unitset:
            out.append(rel); how[rel] = "direct"
            continue
        d = os.path.dirname(rel)
        while d and d not in units:
            d = os.path.dirname(d)
        if not d or d == "tests":
            continue
        if not (WORK / "release-src" / "testsuite" / rel).exists() and os.path.dirname(rel) != d:
            pass
        same = [f"{d}/{u}" for u in units[d] if stem(u) == stem(os.path.basename(rel))]
        if not same and not (WORK / "release-src" / "testsuite" / rel).exists():
            continue        # deleted/renamed aux file with no counterpart
        sel = same or [f"{d}/{u}" for u in units[d]][:40]
        for u in sel:
            if u not in how:
                out.append(u); how[u] = "aux:" + rel
    seen = []
    for u in out:
        if u not in seen:
            seen.append(u)
    return seen, how


def main():
    units = all_units()
    unitset = {f"{d}/{u}" for d, us in units.items() for u in us}
    print("release test units:", len(unitset))
    cands = load("candidates.json")
    m = {}
    for c in cands:
        us, how = map_candidate(c, units, unitset)
        m[c["sha"]] = dict(units=us, how=how)
    save("testmap.json", m)
    need = {u for v in m.values() for u in v["units"]}
    print("candidates with units:", sum(1 for v in m.values() if v["units"]), "/", len(cands))
    print("distinct units needed:", len(need))


if __name__ == "__main__":
    main()
