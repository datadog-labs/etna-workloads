"""Map a fix commit's test files to test units (runner, grep regex) at the release.

Sources of units:
  tests/cases/**            the case file itself
  tests/baselines/reference baseline -> case(s) whose basename is a prefix stem
                            tsc/tsbuild/tscWatch/tsbuildWatch/tsserver scenario dirs ->
                            unittest files declaring that scenario
  src/testRunner/unittests  each top-level describe() title of the file
Each unit records whether the fix added it (case file or unittest file status A,
or a baseline added for a case the fix added).
"""
import functools, os, re, subprocess, sys

sys.path.insert(0, os.path.dirname(__file__))
from tstree import unit_for_case

UNITTEST_BASELINE_DIRS = ("tsc", "tsbuild", "tscWatch", "tsbuildWatch", "tsserver")
TOP_DESCRIBE = re.compile(r'^describe\(\s*"((?:[^"\\]|\\.)*)"', re.M)


def git(repo, *a):
    return subprocess.run(["git", "-C", repo, *a], check=True, capture_output=True, text=True,
                          errors="replace").stdout


class ReleaseIndex:
    def __init__(self, repo, release):
        self.repo, self.release = repo, release
        files = git(repo, "ls-tree", "-r", "--name-only", release, "tests/cases", "src/testRunner/unittests").split("\n")
        self.cases = set(f for f in files if f.startswith("tests/cases/") and unit_for_case(f))
        self.by_stem = {}
        for f in self.cases:
            self.by_stem.setdefault(os.path.basename(f).rsplit(".", 1)[0], []).append(f)
        self.unittests = [f for f in files if f.startswith("src/testRunner/unittests/") and f.endswith(".ts")]
        self._src = {}

    def source(self, path):
        if path not in self._src:
            try:
                self._src[path] = git(self.repo, "show", f"{self.release}:{path}")
            except subprocess.CalledProcessError:
                self._src[path] = None
        return self._src[path]

    def describe_units(self, path):
        src = self.source(path)
        if not src:
            return []
        return [("unittest", "^" + re.escape(t.encode().decode("unicode_escape")) + " ")
                for t in TOP_DESCRIBE.findall(src)]

    def cases_for_baseline(self, name):
        """Baseline basename -> cases whose stem is a '.'/'(' delimited prefix."""
        out = []
        for i, ch in enumerate(name):
            if ch in ".(":
                out += self.by_stem.get(name[:i], [])
        return out

    @functools.lru_cache(maxsize=None)
    def unittests_naming(self, name):
        pat = re.compile(r'["`\'/]' + re.escape(name) + r'["`\'/]')
        return [f for f in self.unittests if (src := self.source(f)) and pat.search(src)]

    @functools.lru_cache(maxsize=None)
    def unittests_for_scenario(self, kind, scenario):
        pat = re.compile(r'(?:scenario|subScenario)?\s*:?\s*["`\']' + re.escape(scenario) + r'["`\']')
        hits = []
        for f in self.unittests:
            if f"/{kind}/" not in f and not (kind.startswith("tsbuild") and "/tsbuild" in f):
                continue
            src = self.source(f)
            if src and pat.search(src):
                hits.append(f)
        return hits


def norm_title(t):
    return re.sub(r"[^a-z0-9]+", "-", t.lower())


def units_for_fix(repo, sha, idx):
    st = git(repo, "diff", "--no-renames", "--name-status", f"{sha}^", sha)
    changes = [l.split("\t", 1) for l in st.splitlines() if l]
    added_cases = set()
    units = {}  # (runner, rx) -> dict

    def add(u, origin, added):
        if not u:
            return
        d = units.setdefault(u, {"runner": u[0], "grep": u[1], "origins": [], "added": False})
        d["origins"].append(origin)
        d["added"] = d["added"] or added

    for status, path in changes:
        if status == "D":
            continue
        if path.startswith("tests/cases/") and path in idx.cases:
            if status == "A":
                added_cases.add(path)
            add(unit_for_case(path), path, status == "A")
    for status, path in changes:
        if status == "D":
            continue
        if path.startswith("tests/baselines/reference/"):
            rel = path[len("tests/baselines/reference/"):]
            parts = rel.split("/")
            if parts[0] in UNITTEST_BASELINE_DIRS and len(parts) >= 3:
                for f in idx.unittests_for_scenario(parts[0], parts[1]):
                    for u in idx.describe_units(f):
                        add(u, path, False)
                        if status == "A":
                            # A new scenario baseline: cases whose title names it were added.
                            key = os.path.splitext(parts[-1])[0]
                            if len(key) >= 12:
                                ks = units[u].setdefault("added_keys", [])
                                if key not in ks:
                                    ks.append(key)
            elif parts[0] == "project" and len(parts) >= 2:
                c = f"tests/cases/project/{parts[1]}.json"
                if c in idx.cases:
                    add(unit_for_case(c), path, c in added_cases)
            elif parts[0] == "api":
                for u in idx.describe_units("src/testRunner/unittests/publicApi.ts"):
                    add(u, path, False)
            elif parts[0] == "transpile" and len(parts) == 2:
                cs = [c for c in idx.cases_for_baseline(parts[1]) if c.startswith("tests/cases/transpile/")]
                for c in cs:
                    add(unit_for_case(c), path, c in added_cases)
                if not cs:
                    for u in idx.describe_units("src/testRunner/unittests/services/transpile.ts"):
                        add(u, path, False)
            elif len(parts) >= 2:
                # Other subdirectories belong to unittests that name them.
                for f in idx.unittests_naming(parts[0]):
                    for u in idx.describe_units(f):
                        add(u, path, False)
            elif len(parts) == 1:
                for c in idx.cases_for_baseline(parts[0]):
                    add(unit_for_case(c), path, c in added_cases)
        elif path.startswith("src/testRunner/unittests/") and path in idx.unittests:
            for u in idx.describe_units(path):
                add(u, path, status == "A")
    return list(units.values())


def main(repo, release, cands, out):
    import json
    idx = ReleaseIndex(repo, release)
    res = {}
    for line in open(cands):
        c = json.loads(line)
        res[c["sha"]] = units_for_fix(repo, c["sha"], idx)
    json.dump(res, open(out, "w"))


if __name__ == "__main__":
    main(*sys.argv[1:])
