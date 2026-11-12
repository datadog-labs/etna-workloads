"""Mine bug-fix candidates reachable from the release.

Candidate = non-merge commit reachable from REL that changes implementation files
in SCOPE (src/) and test files (test/**/*.test*, test/**/*.cpp), with a bug-fix
signal in its own message or in the PR (innermost merge) that brought it in.
Backport duplicates (same patch-id) are collapsed to the oldest commit.
Writes candidates.jsonl.
"""
import json, re, subprocess, sys, collections
from concurrent.futures import ThreadPoolExecutor
import gitlog

REPO, REL, PRMAP, OUT = sys.argv[1:5]

ISSUE_RE = re.compile(
    r"(?:\b(?:fix(?:e[sd])?|close[sd]?|resolve[sd]?|issue)\b\s*:?\s*#\s*(\d{2,6}))"
    r"|(?:\bgh-(\d+))|(?:duckdb/duckdb#(\d+))|(?:github\.com/duckdb/duckdb/(?:issues|discussions)/(\d+))",
    re.I)
INTERNAL_RE = re.compile(r"duckdb-internal\s*#\s*(\d+)", re.I)
FIX_RE = re.compile(r"\b(fix(e[sd]|ing)?|bug(fix)?|crash(es|ing)?|segfault|wrong result|incorrect(ly)?|"
                    r"regression|internal (exception|error)|assertion|overflow|heap[- ]use|use[- ]after|"
                    r"race|deadlock|leak)\b", re.I)
NOT_BUG_RE = re.compile(r"\bfix(e[sd]|ing)?\s+(the\s+)?(ci|tidy|clang[- ]tidy|format(ting)?|typo|typos|"
                        r"lint|warnings?|compil\w*|build|merge|conflicts?|docs?|comment|tests?|"
                        r"test\s+case|benchmark|amalgamation|python|windows build|header)\b"
                        r"|^(format|tidy|merge|wip|revert)\b", re.I)


def is_impl(f):
    return f.startswith("src/")


def test_kind(f):
    if not f.startswith("test/"):
        return None
    if re.search(r"\.test(_slow|_coverage)?$", f):
        return "slt" + ("_slow" if f.endswith("_slow") else "")
    if f.endswith(".cpp"):
        return "cpp"
    return "data"


def signal(text):
    issues = sorted({next(g for g in m.groups() if g) for m in ISSUE_RE.finditer(text)}, key=int)
    internal = sorted(set(INTERNAL_RE.findall(text)), key=int)
    fixw = bool(FIX_RE.search(text))
    notbug = bool(NOT_BUG_RE.search(text))
    return issues, internal, fixw, notbug


prmap = json.load(open(PRMAP))
stats = collections.Counter()
cands = []
for r in gitlog.log_records(REPO, REL):
    impl = [f for f in r["files"] if is_impl(f)]
    kinds = {f: test_kind(f) for f in r["files"]}
    tests = [f for f, k in kinds.items() if k and k != "data"]
    if not impl:
        continue
    if not [f for f, k in kinds.items() if k]:
        continue
    stats["src+test/"] += 1
    if not tests:
        stats["src+test-data-only"] += 1
        continue
    own = r["subject"] + "\n" + r["body"]
    ci, cint, cfix, cnot = signal(own)
    pr = prmap.get(r["sha"])
    prtitle = pr[1] if pr else ""
    prnum = None
    if pr:
        m = re.search(r"Merge pull request #(\d+)", prtitle)
        prnum = m.group(1) if m else None
        pr_text = (pr[2].splitlines()[0] if pr[2] else "") if prnum else prtitle
        pr_text += "\n" + pr[2]
        pi, pint, pfix, pnot = signal(pr_text)
    else:
        pi, pint, pfix, pnot = [], [], False, False
    src = None
    if ci or cint:
        src = "commit-issue"
    elif cfix and not cnot:
        src = "commit-fixword"
    elif (pi or pint) and not cnot:
        src = "pr-issue"
    elif pfix and not pnot and not cnot:
        src = "pr-fixword"
    if not src:
        stats["no-signal"] += 1
        continue
    stats["signal:" + src] += 1
    cands.append(dict(sha=r["sha"], parent=r["parents"][0], time=r["time"], subject=r["subject"],
                      body=r["body"][:4000], impl=impl, tests=tests,
                      test_kinds=sorted({kinds[f] for f in tests}),
                      issues=sorted(set(ci) | set(pi), key=int), internal=sorted(set(cint) | set(pint), key=int),
                      signal=src, pr=prnum, pr_merge=pr[0] if pr else None,
                      pr_title=(pr[2].splitlines()[0] if pr and pr[2] else prtitle)))


def pid(c):
    d = subprocess.run(["git", "-C", REPO, "diff", "--no-renames", c["parent"], c["sha"]], capture_output=True).stdout
    p = subprocess.run(["git", "-C", REPO, "patch-id", "--stable"], input=d, capture_output=True).stdout.split()
    return p[0].decode() if p else None

with ThreadPoolExecutor(16) as ex:
    for c, p in zip(cands, ex.map(pid, cands)):
        c["patch_id"] = p
groups = collections.defaultdict(list)
for c in cands:
    groups[c["patch_id"]].append(c)
keep = []
for g in groups.values():
    g.sort(key=lambda c: c["time"])
    g[0]["duplicates"] = [x["sha"] for x in g[1:]]
    stats["backport-dups-dropped"] += len(g) - 1
    keep.append(g[0])
keep.sort(key=lambda c: -c["time"])
with open(OUT, "w") as f:
    for c in keep:
        f.write(json.dumps(c) + "\n")
stats["candidates"] = len(keep)
for k, v in sorted(stats.items()):
    print(f"{k:28s} {v}")
