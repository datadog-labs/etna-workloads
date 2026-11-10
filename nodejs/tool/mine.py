#!/usr/bin/env python3
"""Mine bug-fix candidates from the Node.js history reachable from a release.

Candidate = non-merge commit reachable from RELEASE that touches implementation
files in scope (lib/, src/; never deps/) AND test files (test/), and carries a
bug-fix signal from the project's own conventions:
  - "Fixes: <issue url | #N>" trailer (node style since io.js)
  - "Fixes #N" / "Closes #N" / "fix #N" (joyent-era style)
  - CVE-ID trailer or hackerone report reference (security fixes)
  - fix wording in the subject (fix, bug, crash, regression, leak, ...)
Backport duplicates are dropped: if two reachable commits share a PR-URL or
a patch-id, only the oldest is kept.

Output: JSONL, one candidate per line, newest first.
"""
import argparse, json, re, subprocess, sys
from collections import defaultdict

SEP = "\x1e"
SCOPE_PREFIXES = ("lib/", "src/")
TEST_PREFIX = "test/"

FIXES_TRAILER = re.compile(r"^Fixes:\s*(\S+)", re.M | re.I)
OLD_FIXES = re.compile(r"\b(?:fix(?:e[sd])?|close[sd]?|resolve[sd]?)\s+(?:gh-|issue\s+)?#(\d+)", re.I)
CVE = re.compile(r"^CVE-ID:\s*(\S+)", re.M)
HACKERONE = re.compile(r"hackerone\.com/reports/\d+")
PR_URL = re.compile(r"^PR-URL:\s*(\S+)", re.M)
REFS = re.compile(r"^Refs?:\s*(\S+)", re.M)
FIX_WORDS = re.compile(
    r"\b(fix(e[sd]|ing)?|bug(s|fix)?|crash(es|ing)?|segfault|regression|leak(s|ing)?|"
    r"incorrect(ly)?|wrong(ly)?|broken|hang(s|ing)?|deadlock|race|overflow|"
    r"use-after-free|uaf|null pointer|assertion|abort(s)?)\b", re.I)
NOT_FIX_SUBJ = re.compile(r"^(Revert|doc|test|tools|build|benchmark|meta|deps)\b", re.I)


def git(repo, *args):
    return subprocess.run(["git", "-C", repo, *args], check=True,
                          capture_output=True, text=True, errors="replace").stdout


def is_impl(path):
    return path.startswith(SCOPE_PREFIXES)


def test_kind(path):
    parts = path.split("/")
    return parts[1] if len(parts) > 2 else "other"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", required=True)
    ap.add_argument("--release", required=True)
    ap.add_argument("--out", required=True)
    a = ap.parse_args()

    log = git(a.repo, "log", "--no-merges", "--no-renames", "--name-only",
              f"--format={SEP}%H%x00%P%x00%cI%x00%aI%x00%B%x00", a.release)
    commits = []
    for chunk in log.split(SEP)[1:]:
        sha, parents, cdate, adate, body, files = chunk.split("\x00", 5)
        files = [f for f in files.strip().splitlines() if f]
        commits.append(dict(sha=sha, parents=parents.split(), cdate=cdate,
                            adate=adate, body=body.strip(), files=files))
    print(f"non-merge commits reachable: {len(commits)}", file=sys.stderr)

    cands = []
    for c in commits:
        impl = [f for f in c["files"] if is_impl(f)]
        tests = [f for f in c["files"] if f.startswith(TEST_PREFIX)]
        if not impl or not tests:
            continue
        body = c["body"]
        subject = body.splitlines()[0] if body else ""
        sig = []
        fx = FIXES_TRAILER.findall(body)
        if fx:
            sig.append("fixes-trailer")
        if OLD_FIXES.search(body):
            sig.append("fixes-#N")
        if CVE.search(body):
            sig.append("cve")
        if HACKERONE.search(body):
            sig.append("hackerone")
        if FIX_WORDS.search(subject):
            sig.append("fix-wording")
        if not sig:
            continue
        if subject.startswith("Revert"):
            continue  # reverts re-introduce old behaviour; not a fix signal by themselves
        prs = PR_URL.findall(body)
        links = sorted(set(fx + REFS.findall(body) + HACKERONE.findall(body)))
        cands.append(dict(
            sha=c["sha"], date=c["adate"], commit_date=c["cdate"],
            subject=subject, signals=sig, pr_url=prs[0] if prs else None,
            links=links, cve=CVE.findall(body), impl_files=impl,
            test_files=tests, test_kinds=sorted({test_kind(t) for t in tests}),
            body=body))

    # Backport duplicates: same PR-URL among reachable commits -> keep oldest.
    by_pr = defaultdict(list)
    for c in cands:
        if c["pr_url"]:
            by_pr[c["pr_url"]].append(c)
    drop = set()
    for pr, cs in by_pr.items():
        if len(cs) > 1:
            cs.sort(key=lambda c: c["commit_date"])
            for c in cs[1:]:
                drop.add(c["sha"])
    # Same patch-id (cherry-picks without PR-URL, joyent/io.js merges).
    keep = "\n".join(c["sha"] for c in cands if c["sha"] not in drop) + "\n"
    pid_in = subprocess.run(["git", "-C", a.repo, "log", "--no-walk=unsorted", "--stdin",
                             "--format=commit %H", "-p", "--", *SCOPE_PREFIXES],
                            input=keep, capture_output=True, text=True, errors="replace").stdout
    pids = subprocess.run(["git", "-C", a.repo, "patch-id", "--stable"], input=pid_in,
                          capture_output=True, text=True, errors="replace").stdout
    by_pid = defaultdict(list)
    date = {c["sha"]: c["commit_date"] for c in cands}
    for line in pids.splitlines():
        pid, sha = line.split()
        by_pid[pid].append(sha)
    for pid, shas in by_pid.items():
        if len(shas) > 1:
            shas.sort(key=lambda s: date[s])
            drop.update(shas[1:])
    out = [c for c in cands if c["sha"] not in drop]
    out.sort(key=lambda c: c["date"], reverse=True)
    with open(a.out, "w") as f:
        for c in out:
            f.write(json.dumps(c) + "\n")
    print(f"candidates (before dedup): {len(cands)}; duplicates dropped: {len(drop)}; "
          f"candidates: {len(out)}", file=sys.stderr)


if __name__ == "__main__":
    main()
