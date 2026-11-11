"""Probe: does the reversed implementation diff of each candidate apply to the release?

clean   = git apply -R --check succeeds
fuzzy   = GNU patch -R --dry-run with fuzz succeeds (offsets/fuzz)
conflict= neither
Writes data/probe.json and prints the summary tables.
"""
import re, shutil, subprocess, sys, tempfile
from collections import Counter, defaultdict
from concurrent.futures import ThreadPoolExecutor
from common import *

SRC = WORK / "release-src"


def impl_diff(c):
    return git("diff", "--binary", "--no-renames", f"{c['sha']}^", c["sha"], "--", *c["impl_files"])


def test_kind(c):
    kinds = set()
    for f in c["test_files"]:
        if f.endswith(".reference"):
            kinds.add("reference")
    for f in c["test_files"]:
        if f.endswith(".ml") and f.startswith("testsuite/tests/"):
            txt = git("show", f"{c['sha']}:{f}", check=False)
            head = txt[:3000]
            if re.search(r"\bexpect\b", head) and "(* TEST" in head:
                kinds.add("expect")
            elif "(* TEST" in head or "(*TEST" in head:
                kinds.add("ocamltest")
    if not kinds:
        kinds.add("legacy/other")
    # one label per candidate, by precedence
    for k in ("expect", "reference", "ocamltest", "legacy/other"):
        if k in kinds:
            return k


def check(c):
    d = impl_diff(c)
    r = subprocess.run(["git", "apply", "-R", "--check", "-"], cwd=SRC, input=d,
                       capture_output=True, text=True)
    if r.returncode == 0:
        status = "clean"
    else:
        r2 = subprocess.run(["patch", "-p1", "-R", "--dry-run", "--batch", "-F3", "-s"],
                            cwd=SRC, input=d, capture_output=True, text=True)
        status = "fuzzy" if r2.returncode == 0 else "conflict"
    return dict(sha=c["sha"], status=status, kind=test_kind(c),
                diff_lines=d.count("\n"),
                touches_mly=any(f.endswith(".mly") for f in c["impl_files"]))


def main():
    cands = load("candidates.json")
    with ThreadPoolExecutor(12) as ex:
        res = list(ex.map(check, cands))
    save("probe.json", res)
    by = {r["sha"]: r for r in res}
    tot = Counter(r["status"] for r in res)
    print("total", len(res), dict(tot))
    year = defaultdict(Counter)
    kind = defaultdict(Counter)
    for c in cands:
        r = by[c["sha"]]
        year[c["date"][:4]][r["status"]] += 1
        kind[r["kind"]][r["status"]] += 1
    print("\nyear  total clean fuzzy conflict")
    for y in sorted(year):
        v = year[y]
        print(f"{y}  {sum(v.values()):5} {v['clean']:5} {v['fuzzy']:5} {v['conflict']:5}")
    print("\nkind  total clean fuzzy conflict")
    for k in sorted(kind):
        v = kind[k]
        print(f"{k:14} {sum(v.values()):5} {v['clean']:5} {v['fuzzy']:5} {v['conflict']:5}")
    mly = Counter(r["status"] for r in res if r["touches_mly"])
    print("\ntouches parser.mly:", dict(mly))


if __name__ == "__main__":
    main()
