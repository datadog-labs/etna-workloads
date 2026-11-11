"""Mine bug-fix candidates reachable from the release.

Candidate = non-merge commit touching SCOPE implementation files and
testsuite/ files, with a bug-fix signal.  Output: data/candidates.json
"""
import re, sys
from collections import Counter
from common import *

FIX_WORDS = re.compile(r"\b(fix(es|ed|ing)?|bug|regression|crash(es)?|segfault|"
                       r"wrong|incorrect|miscompil\w*|assert(ion)? fail\w*|"
                       r"broken|unsound\w*|soundness|leak|race|deadlock|hang)\b", re.I)
REF = re.compile(r"(?:\b(?:M?PR|GPR|gh|issue)\s*#?\s*-?|(?<![\w/])#)(\d{2,6})\b", re.I)
CHERRY = re.compile(r"cherry picked from commit ([0-9a-f]{40})")


def changes_categories(sha):
    """Categories ('### ...' headers) of lines this commit added to Changes."""
    diff = git("diff", "-U0", f"{sha}^", sha, "--", "Changes", check=False)
    if not diff:
        return [], []
    added_lines = []
    added_text = []
    for m in re.finditer(r"^@@ -\S+ \+(\d+)(?:,(\d+))? @@", diff, re.M):
        start, n = int(m.group(1)), int(m.group(2) or 1)
        added_lines.extend(range(start, start + n))
    for line in diff.splitlines():
        if line.startswith("+") and not line.startswith("+++"):
            added_text.append(line[1:])
    if not added_lines:
        return [], added_text
    content = git("show", f"{sha}:Changes", check=False).splitlines()
    cats = set()
    for ln in added_lines:
        for i in range(min(ln, len(content)) - 1, -1, -1):
            if content[i].startswith("### "):
                cats.add(content[i][4:].strip().rstrip(":"))
                break
            if re.match(r"^(OCaml|Working version|Next)", content[i]):
                break
    return sorted(cats), added_text


def main():
    reachable = set(git("rev-list", RELEASE).split())
    fmt = "\x1e%H\x1f%P\x1f%ct\x1f%ci\x1f%an\x1f%s\x1f%b\x1f"
    out = git("log", "--no-merges", "--no-renames", "--name-only", f"--format={fmt}", RELEASE)
    commits = []
    for rec in out.split("\x1e")[1:]:
        parts = rec.split("\x1f")
        sha, parents, ct, ci, an, subj, body, files = parts
        files = [f for f in files.strip().splitlines() if f]
        commits.append(dict(sha=sha, parents=parents.split(), ts=int(ct), date=ci,
                            author=an, subject=subj, body=body.strip(), files=files))
    print(f"non-merge commits reachable: {len(commits)}", file=sys.stderr)
    stats = Counter()
    cands, rejects = [], []
    # Reverted commits are not in the release's behaviour; reverts themselves are not fixes.
    reverted = set()
    for c in commits:
        for m in re.finditer(r"This reverts commit ([0-9a-f]{40})", c["body"]):
            if m.group(1) in reachable:
                reverted.add(m.group(1))
                reverted.add(c["sha"])
    for c in commits:
        impl = [f for f in c["files"] if is_impl(f)]
        tests = [f for f in c["files"] if is_test(f)]
        if not impl or not tests:
            continue
        stats["impl+test"] += 1
        msg = c["subject"] + "\n" + c["body"]
        if c["sha"] in reverted:
            stats["revert-or-reverted"] += 1
            continue
        m = CHERRY.findall(msg)
        if any(s in reachable for s in m):
            stats["backport-of-reachable"] += 1
            continue
        cats, added = changes_categories(c["sha"]) if "Changes" in c["files"] else ([], [])
        refs = sorted(set(REF.findall(c["subject"] + "\n" + c["body"] + "\n" + "\n".join(added))), key=int)
        signals = []
        if FIX_WORDS.search(msg):
            signals.append("fix-wording")
        if re.search(r"\b(fixes|closes|fix)\s+#\d+", msg, re.I):
            signals.append("fixes-trailer")
        if re.match(r"\s*(M?PR|GPR|gh)\s*#?-?\d+", c["subject"], re.I) or re.search(r"\(#\d+\)\s*$", c["subject"]):
            signals.append("ticket-subject")
        if "Bug fixes" in cats:
            signals.append("news-bugfix")
        if added and FIX_WORDS.search("\n".join(added)):
            signals.append("news-fix-wording")
        if re.search(r"\b(M?PR|MPR)\s*#?\s*\d{4}", msg):
            signals.append("mantis-ticket")   # Mantis tickets were bug reports
        if not (set(signals) & {"fix-wording", "fixes-trailer", "news-bugfix", "news-fix-wording", "mantis-ticket"}):
            stats["no-fix-signal"] += 1
            rejects.append(c["sha"][:10] + " " + c["date"][:10] + " " + c["subject"][:90] + "  " + str(cats))
            continue
        c.update(impl_files=impl, test_files=tests, signals=signals,
                 news_categories=cats, refs=refs, cherry_of=m)
        cands.append(c)
    # Dedupe patch-identical commits (backports without a cherry-pick trailer); keep newest.
    final, seen = [], {}
    for c in cands:
        pid = git("patch-id", "--stable", input=git("show", c["sha"])).split()
        key = pid[0] if pid else c["sha"]
        if key in seen:
            stats["duplicate-patch-id"] += 1
            seen[key].setdefault("duplicates", []).append(c["sha"])
            continue
        seen[key] = c
        final.append(c)
    stats["candidates"] = len(final)
    print(dict(stats), file=sys.stderr)
    save("candidates.json", final)
    save("rejects_nosignal.json", rejects)


if __name__ == "__main__":
    main()
