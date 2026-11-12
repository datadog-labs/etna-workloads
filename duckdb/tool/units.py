"""Map a candidate's test files to test units that exist at the release.

slt file  -> one unit (the file path; the runner reports at file granularity)
cpp file  -> one unit per TEST_CASE in the release version of the file: "cpp:<file>::<name>"
Also records which units the fix itself added (file added by the fix, or TEST_CASE name
not present in the fix's parent version of the file).
"""
import os, re, subprocess

TC_RE = re.compile(r'TEST_CASE\s*\(\s*"((?:[^"\\]|\\.)*)"')


def cpp_cases(text):
    return [bytes(m.group(1), "utf-8").decode("unicode_escape") for m in TC_RE.finditer(text)]


def git_show(repo, rev, path):
    r = subprocess.run(["git", "-C", repo, "show", f"{rev}:{path}"], capture_output=True)
    return r.stdout.decode("utf-8", "replace") if r.returncode == 0 else None


def candidate_units(repo, release_tree, c):
    units, added = [], []
    for f in c["tests"]:
        rel = os.path.join(release_tree, f)
        if not os.path.exists(rel):
            continue
        before = git_show(repo, c["parent"], f)
        if f.endswith(".cpp"):
            now = cpp_cases(open(rel, errors="replace").read())
            fixed = set(cpp_cases(git_show(repo, c["sha"], f) or ""))
            prev = set(cpp_cases(before or ""))
            for n in now:
                u = f"cpp:{f}::{n}"
                units.append(u)
                if n in fixed and n not in prev:
                    added.append(u)
        else:
            units.append(f)
            if before is None:
                added.append(f)
    return units, added
