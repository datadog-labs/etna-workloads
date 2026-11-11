#!/usr/bin/env python3
"""List candidate fix commits reachable from RELEASE that touch impl (SCOPE) and test files."""
import json, os, sys, collections
sys.path.insert(0, os.path.dirname(__file__))
from common import *

def main():
    os.makedirs(DATA, exist_ok=True)
    out = git("log", "--no-merges", "--format=\x01%H\x02%ct\x02%s\x02%b\x03", "--name-only", RELEASE)
    commits = []
    for chunk in out.split("\x01")[1:]:
        head, _, files = chunk.partition("\x03")
        h, ct, subj, body = head.split("\x02", 3)
        files = [f for f in files.split("\n") if f.strip()]
        commits.append(dict(sha=h, time=int(ct), subject=subj, body=body.strip(), files=files))
    stats = collections.Counter(total=len(commits))
    cands = []
    for c in commits:
        impl = [f for f in c["files"] if is_impl(f)]
        tests = [f for f in c["files"] if is_test(f)]
        if not impl: continue
        stats["impl"] += 1
        msg = c["subject"] + "\n" + c["body"]
        issues = sorted(set(ISSUE_RE.findall(msg)) | set(BARE_ISSUE_RE.findall(c["subject"])), key=int)
        fixword = bool(FIX_WORD_RE.search(msg))
        isfix = bool(issues) or fixword
        if isfix: stats["impl_fix"] += 1
        if not tests: continue
        stats["impl_test"] += 1
        if not isfix: continue
        stats["impl_test_fix"] += 1
        pr = PR_RE.search(c["subject"])
        cands.append(dict(sha=c["sha"], time=c["time"], subject=c["subject"], body=c["body"][:2000],
                          impl=impl, tests=tests, issues=issues, pr=pr.group(1) if pr else None,
                          signal="issue" if issues else "fixword"))
    # dedupe backports by patch-id
    seen = {}
    pid_out = git("patch-id", "--stable", input="".join(git("show", c["sha"]) for c in cands))
    pids = {l.split()[1]: l.split()[0] for l in pid_out.splitlines()}
    final = []
    for c in sorted(cands, key=lambda c: c["time"]):
        p = pids.get(c["sha"])
        if p and p in seen:
            stats["dup_backport"] += 1; continue
        seen[p] = c["sha"]; final.append(c)
    final.sort(key=lambda c: -c["time"])
    json.dump(final, open(os.path.join(DATA, "candidates.json"), "w"), indent=1)
    stats["candidates"] = len(final)
    print(json.dumps(stats, indent=1))

if __name__ == "__main__":
    main()
