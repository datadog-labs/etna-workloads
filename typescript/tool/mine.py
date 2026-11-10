#!/usr/bin/env python3
"""Mine bug-fix candidates for the TypeScript compiler from git history.

Candidate = non-merge commit reachable from the release that changes
implementation files in scope (src/compiler, src/services) and test files,
and carries a bug-fix signal. Writes candidates.jsonl.

Usage: mine.py REPO RELEASE OUT.jsonl
"""
import json, re, subprocess, sys

SCOPE = ("src/compiler/", "src/services/")
# Implementation = shipped source outside test-only code and lib .d.ts files.
NON_IMPL_SRC = ("src/lib/", "src/testRunner/", "src/harness/", "src/loc/")
TEST_PREFIXES = ("tests/", "src/testRunner/", "src/harness/")

FIX_RE = re.compile(
    r"\b(fix(e[sd])?|fixing|bug|crash(es|ed)?|regression|incorrect(ly)?|wrong|"
    r"broken|erroneous|spurious|missing|should not|shouldn't|doesn't|does not|"
    r"don't|do not|prevent|avoid|handle|correct(ly)?|issue)\b", re.I)
REF_RE = re.compile(r"\b(fix(e[sd])?|close[sd]?|resolve[sd]?)\s*:?\s*(#\d+|https://github\.com/microsoft/TypeScript/issues/\d+)", re.I)
NOT_FIX_SUBJ = re.compile(r"^(Update (LKG|baselines?|dependencies|DOM)|Bump |LKG|Merge |DOM update|Revert )", re.I)
# "quick fix"/"codefix" name a language-service feature, not a bug fix.
FEATURE_FIX_RE = re.compile(r"\b(quick ?fix(es)?|code ?fix(es)?|fix[- ]all|lint fix(es)?|fixes for lint)\b", re.I)
PICK_RE = re.compile(r"Pick PR #(\d+)")
PR_RE = re.compile(r"\(#(\d+)\)\s*$")


def git(repo, *args):
    return subprocess.run(["git", "-C", repo, *args], check=True,
                          capture_output=True, text=True, errors="replace").stdout


def is_impl(p):
    return p.startswith("src/") and not p.startswith(NON_IMPL_SRC)


def test_kind(p):
    m = re.match(r"tests/cases/(compiler|conformance|fourslash|transpile|project|projects|unittests)/", p)
    if m:
        k = m.group(1)
        return "fourslash-server" if p.startswith("tests/cases/fourslash/server/") else ("project" if k == "projects" else k)
    if p.startswith("src/testRunner/unittests/"):
        return "unittests"
    if p.startswith("tests/baselines/reference/"):
        return "baseline-only"
    return None


def main(repo, release, out):
    log = git(repo, "log", release, "--no-merges", "--format=%x00%H%x01%ct%x01%s%x01%b%x02",
              "--name-only", "--no-renames")
    commits = []
    for chunk in log.split("\x00")[1:]:
        head, _, files = chunk.partition("\x02")
        h, ct, subj, body = head.split("\x01", 3)
        files = [f for f in files.strip().splitlines() if f]
        commits.append(dict(sha=h, time=int(ct), subject=subj, body=body.strip(), files=files))

    reachable_prs = {}
    for c in commits:
        m = PR_RE.search(c["subject"])
        if m and not PICK_RE.search(c["subject"]):
            reachable_prs[m.group(1)] = c["sha"]

    n = 0
    with open(out, "w") as f:
        for c in commits:
            impl = [p for p in c["files"] if is_impl(p)]
            scope = [p for p in impl if p.startswith(SCOPE)]
            tests = [p for p in c["files"] if p.startswith(TEST_PREFIXES) and not is_impl(p)]
            if not scope or not tests:
                continue
            text = c["subject"] + "\n" + c["body"]
            if NOT_FIX_SUBJ.search(c["subject"]):
                continue
            ref = REF_RE.search(text)
            subj = FEATURE_FIX_RE.sub("", c["subject"])
            if not (ref or FIX_RE.search(subj)):
                continue
            pick = PICK_RE.search(c["subject"])
            if pick and pick.group(1) in reachable_prs:
                continue  # backport of a reachable commit
            kinds = sorted({k for k in map(test_kind, tests) if k})
            if any(k != "baseline-only" for k in kinds):
                kinds = [k for k in kinds if k != "baseline-only"]
            issues = sorted(set(re.findall(r"(?:#|/issues/)(\d{3,6})\b", text)))
            pr = PR_RE.search(c["subject"])
            f.write(json.dumps(dict(
                sha=c["sha"], time=c["time"], subject=c["subject"], body=c["body"][:4000],
                impl_files=impl, scope_files=scope, test_files=tests, test_kinds=kinds,
                signal="ref" if ref else "wording", pr=pr.group(1) if pr else None,
                pick_of=pick.group(1) if pick else None, issues=issues)) + "\n")
            n += 1
    print(f"{len(commits)} non-merge commits, {n} candidates", file=sys.stderr)


if __name__ == "__main__":
    main(*sys.argv[1:])
