#!/usr/bin/env python3
"""Mine candidate bug-fix commits reachable from the release.

Output: data/commits.jsonl (every non-merge commit since SINCE with PR info and
file classification) and data/candidates.jsonl (the candidate subset).
"""
import json
import os
import re
import sys
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, RELEASE, SINCE, git, is_impl, test_suite  # noqa: E402

AUTO = re.compile(r"^Auto merge of #(\d+) - (\S+)")
ROLLUP = re.compile(r"^Rollup merge of #(\d+) - (\S+)")
MPR = re.compile(r"^Merge pull request #(\d+) from (\S+)")
BACKPORT = re.compile(r"(beta|stable)[-_](next|backport)|backport|\[beta\]|\[stable\]", re.I)

ISSUE_REF = re.compile(
    r"\b(?:fix(?:e[sd])?|close[sd]?|resolve[sd]?)\b[:\s]+"
    r"((?:(?:rust-lang/rust)?#\d+|https://github\.com/rust-lang/rust/issues/\d+)"
    r"(?:[\s,]+(?:and\s+)?(?:(?:rust-lang/rust)?#\d+|https://github\.com/rust-lang/rust/issues/\d+))*)",
    re.I)
FIX_WORD = re.compile(
    r"\b(fix(e[sd])?|ICE|bug|regression|crash(es)?|panic(s)?|unsound(ness)?|"
    r"wrong|incorrect(ly)?|miscompil\w*|don'?t|do not|avoid|prevent|properly|"
    r"correctly|erroneous|spurious|bogus)\b", re.I)


def merge_info(h):
    out = git("log", "-1", "--format=%P%x00%s%x00%b", h)
    parents, subj, body = out.split("\x00", 2)
    return parents.split(), subj, body.strip("\n")


def mainline_merges():
    """bors merges on the release's first-parent chain."""
    out = git("rev-list", "--first-parent", "--merges", f"--since={SINCE}", RELEASE)
    return out.split()


def pr_jobs(m):
    """For a mainline merge, return [(kind, pr, branch, merge, title, body, commits)]."""
    ps, subj, body = merge_info(m)
    res = []
    if len(ps) != 2:
        return res
    for kind, rx in (("auto", AUTO), ("mpr", MPR)):
        mm = rx.match(subj)
        if mm:
            break
    else:
        return res
    # Rollup members: merges on the PR side's first-parent chain.
    for r in git("rev-list", "--first-parent", "--merges", f"{ps[0]}..{ps[1]}").split():
        rps, rsubj, rbody = merge_info(r)
        rm = ROLLUP.match(rsubj)
        if rm and len(rps) == 2:
            res.append(("rollup", int(rm.group(1)), rm.group(2), r, rsubj, rbody,
                        git("rev-list", "--no-merges", f"{rps[0]}..{rps[1]}").split()))
    res.append((kind, int(mm.group(1)), mm.group(2), m, subj, body,
                git("rev-list", "--no-merges", f"{ps[0]}..{ps[1]}").split()))
    return res


def issue_refs(text):
    refs = set()
    for m in ISSUE_REF.finditer(text):
        for n in re.findall(r"(\d+)", m.group(1)):
            refs.add(int(n))
    return sorted(refs)


def main():
    os.makedirs(DATA, exist_ok=True)
    ms = mainline_merges()
    print(f"mainline merges since {SINCE}: {len(ms)}", file=sys.stderr)
    pr_of = {}
    with ThreadPoolExecutor(16) as ex:
        results = [j for js in ex.map(pr_jobs, ms) for j in js]
    # Innermost PR wins: rollup members before the rollup's own auto merge.
    order = {"rollup": 0, "mpr": 1, "auto": 2}
    results.sort(key=lambda r: order[r[0]])
    for kind, pr, branch, h, subj, body, cs in results:
        lines = [line for line in body.splitlines() if line.strip()]
        title = lines[0] if lines else subj
        bp = bool(BACKPORT.search(branch) or BACKPORT.search(title))
        for c in cs:
            if c in pr_of:
                continue
            pr_of[c] = dict(pr=pr, merge_kind=kind, merge=h, branch=branch,
                            pr_title=title, pr_body=body[:20000], backport=bp)
    print(f"commits with PR: {len(pr_of)}", file=sys.stderr)

    log = git("log", "--no-merges", f"--since={SINCE}", "--no-renames",
              "--format=\x1e%H%x00%ci%x00%an%x00%s%x00%b%x00", "--name-status", RELEASE)
    commits = []
    for rec in log.split("\x1e"):
        if not rec.strip():
            continue
        h, date, author, subj, body, files = rec.split("\x00", 5)
        status = []
        for line in files.strip().splitlines():
            parts = line.split("\t")
            if len(parts) >= 2:
                status.append((parts[0][0], parts[-1]))
        impl = [p for s, p in status if is_impl(p)]
        tests = [(s, p) for s, p in status if test_suite(p)]
        info = pr_of.get(h, {})
        text = "\n".join([subj, body, info.get("pr_title", ""), info.get("pr_body", "")])
        refs = issue_refs(text)
        commits.append(dict(
            commit=h, date=date, author=author, subject=subj, body=body[:5000],
            impl_files=impl,
            other_impl=[p for s, p in status if not is_impl(p) and not test_suite(p)
                        and not p.startswith("compiler/")
                        and p.startswith(("library/", "src/"))],
            test_files=[p for s, p in tests],
            tests_added=[p for s, p in tests if s == "A"],
            tests_deleted=[p for s, p in tests if s == "D"],
            suites=sorted({test_suite(p) for s, p in tests}),
            issue_refs=refs,
            fix_word=bool(FIX_WORD.search(subj) or FIX_WORD.search(info.get("pr_title", ""))),
            **{k: v for k, v in info.items() if k != "pr_body"},
        ))
    print(f"non-merge commits since {SINCE}: {len(commits)}", file=sys.stderr)

    # Backport duplicates: same patch-id as another reachable commit.
    bp = [c for c in commits if c.get("backport")]
    ids = {}
    if bp:
        def pid(h):
            out = git("show", h, "--format=")
            r = git("patch-id", "--stable", input=out.encode())
            return h, (r.split() or [None])[0]
        cand_like = [c["commit"] for c in commits if c["impl_files"] and c["test_files"]]
        with ThreadPoolExecutor(16) as ex:
            ids = dict(ex.map(pid, cand_like))
    seen = {}
    for c in commits:
        p = ids.get(c["commit"])
        if p and not c.get("backport"):
            seen.setdefault(p, c["commit"])
    for c in commits:
        p = ids.get(c["commit"])
        c["backport_dup_of"] = seen.get(p) if c.get("backport") and p in seen else None

    with open(os.path.join(DATA, "commits.jsonl"), "w") as f:
        for c in commits:
            f.write(json.dumps(c) + "\n")
    cands = [c for c in commits
             if c["impl_files"] and c["test_files"] and not c["backport_dup_of"]
             and (c["issue_refs"] or c["fix_word"])]
    with open(os.path.join(DATA, "candidates.jsonl"), "w") as f:
        for c in cands:
            f.write(json.dumps(c) + "\n")
    print(f"impl+test commits: {sum(1 for c in commits if c['impl_files'] and c['test_files'])}",
          file=sys.stderr)
    print(f"candidates: {len(cands)}", file=sys.stderr)


if __name__ == "__main__":
    main()
