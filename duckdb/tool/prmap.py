"""Map each non-merge commit to the innermost (oldest) merge commit that brought it in.

Merges are processed oldest first (reverse topo order); a commit is assigned to
the first merge whose M^1..M^2 range contains it. Output: JSON {sha: [merge_sha, merge_subject, merge_body]}.
"""
import json, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

repo, rev, out = sys.argv[1:4]
merges = subprocess.run(["git", "-C", repo, "log", "--merges", "--topo-order", "--reverse",
                         "--format=%H%x1f%P%x1f%s%x1f%b%x1e", rev],
                        check=True, capture_output=True).stdout.decode("utf-8", "replace")
recs = []
for m in merges.split("\x1e"):
    m = m.strip("\n")
    if not m:
        continue
    h, p, s, b = m.split("\x1f")
    p = p.split()
    recs.append((h, p, s, b.strip()))


def rng(rec):
    h, p, s, b = rec
    r = subprocess.run(["git", "-C", repo, "rev-list", "--no-merges", f"{p[0]}..{p[1]}"],
                       capture_output=True)
    return r.stdout.decode().split()

assign = {}
with ThreadPoolExecutor(16) as ex:
    for rec, shas in zip(recs, ex.map(rng, recs)):
        for c in shas:
            if c not in assign:
                assign[c] = [rec[0], rec[2], rec[3][:2000]]
json.dump(assign, open(out, "w"))
print(len(recs), "merges;", len(assign), "commits assigned")
