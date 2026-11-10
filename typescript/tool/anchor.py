#!/usr/bin/env python3
"""Anchor check for adapted bugs, at the original fix commit.

At the fix commit F: build F, run the units holding the adapted bug's failing
cases (they must pass at F). Then reverse F's implementation diff (= parent's
code with F's tests), rebuild, run twice. Anchor is "exact" iff some case that
passes at F, fails in both reversed runs, and is among the adapted bug's
failing cases at the release.

Only revisions from the hereby/modules era (>= 2022-11-07) are supported; older
ones are recorded as "unsupported_revision" (they need the old gulp build).

Usage: anchor.py ADAPTED_RESULT_DIR [...]
"""
import fcntl, hashlib, json, os, re, shutil, subprocess, sys, time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import gate, inject, proc, tstree

W = tstree.WORK
REPO = gate.REPO
NM = os.path.join(W, "nm")
HEREBY_ERA = 1667779200


def case_key(t):
    """Title modulo cosmetic renames across revisions: configuration labels such as
    ' (@target: es5)' (added when TS 6 changed defaults) and '::' suite separators."""
    t = re.sub(r" \((?:@[^()]*|[a-z]+=[^()]*)\)", "", t)
    return re.sub(r"\s+", " ", t.replace("::", " ")).strip()


def relax(runner, grep):
    # Suites renamed 'unittests:: x:: y' -> 'unittests:: x:: y::' since the fix.
    if runner == "unittest":
        for end in ("::\\ ", ":: "):
            if grep.endswith(end):
                return grep[:-len(end)] + "(?:::)? "
    return grep


def node_modules_for(tree, log):
    lock = open(os.path.join(tree, "package-lock.json"), "rb").read()
    h = hashlib.sha256(lock + open(os.path.join(tree, "package.json"), "rb").read()).hexdigest()[:16]
    d = os.path.join(NM, h)
    os.makedirs(NM, exist_ok=True)
    lockf = open(d + ".lock", "w")
    fcntl.flock(lockf, fcntl.LOCK_EX)  # one installer per lockfile; others wait
    if not os.path.exists(os.path.join(d, ".done")):
        tstree.rm_tree(d)  # chmods u+w first; partial caches are read-only
        os.makedirs(d)
        for f in ("package.json", "package-lock.json"):
            shutil.copy(os.path.join(tree, f), d)
        rc, reason = proc.run(["npm", "ci", "--no-audit", "--no-fund", "--ignore-scripts"], d, log,
                              timeout=900, rss_mb=8192)
        if rc != 0:
            return None
        open(os.path.join(d, ".done"), "w").close()
        subprocess.run(["chmod", "-R", "a-w", os.path.join(d, "node_modules")])
    return os.path.join(d, "node_modules")


def anchor(res_dir, cands):
    res_dir = os.path.abspath(res_dir)
    r = json.load(open(os.path.join(res_dir, "result.json")))
    short = os.path.basename(res_dir.rstrip("/"))
    c = next(c for s, c in cands.items() if s.startswith(short))
    sha = c["sha"]
    out = {"sha": sha}
    try:
        if c["time"] < HEREBY_ERA or subprocess.run(["git", "-C", REPO, "cat-file", "-e", f"{sha}:Herebyfile.mjs"],
                                                     capture_output=True).returncode != 0:
            out["status"] = "unsupported_revision"
            return out
        failing = set(r.get("failing", []))
        if not failing:
            out["status"] = "no_release_failures"
            return out
        oracle = json.load(open(os.path.join(res_dir, "oracle.json")))
        units = sorted({(oracle[t]["runner"], relax(oracle[t]["runner"], oracle[t]["grep"])) for t in failing})
        tree = os.path.join(W, "trees", f"anchor-{short}")
        tstree.rm_tree(tree)
        os.makedirs(tree)
        a = subprocess.run(["git", "-C", REPO, "archive", sha], capture_output=True, check=True).stdout
        subprocess.run(["tar", "-x", "-C", tree], input=a, check=True)
        os.makedirs(os.path.join(tree, "tests/baselines/local"), exist_ok=True)
        os.makedirs(os.path.join(tree, ".tmp"), exist_ok=True)
        log = os.path.join(res_dir, "anchor.log")
        nm = node_modules_for(tree, log)
        if not nm:
            out["status"] = "npm_failed"
            return out
        os.symlink(nm, os.path.join(tree, "node_modules"))
        ok, reason = tstree.build(tree, os.path.join(res_dir, "anchor-build-fix.log"))
        if not ok:
            out["status"] = "build_failed_at_fix"
            return out
        j = os.path.join(res_dir, "anchor-fix.jsonl")
        if os.path.exists(j):
            os.unlink(j)
        tstree.run_units(tree, units, j, log, timeout=2400)
        at_fix, _ = tstree.parse(j)
        passing_fix = {t for t in failing if tstree.case_status(at_fix, t) == "pass"}
        out["pass_at_fix"] = len(passing_fix)
        if not at_fix:
            out["status"] = "no_cases_at_fix"  # nothing reported: a tooling problem, not a result
            return out
        d = subprocess.run(["git", "-C", REPO, "diff", "--no-renames", "--binary", f"{sha}^", sha, "--",
                            *c["impl_files"]], capture_output=True, check=True).stdout
        ok, _, msg = inject.apply_patch(tree, d, reverse=True)
        if not ok:
            out["status"] = "reverse_failed_at_fix"
            return out
        ok, reason = tstree.build(tree, os.path.join(res_dir, "anchor-build-reversed.log"))
        if not ok:
            out["status"] = "build_failed_reversed"
            return out
        runs = []
        for k in (1, 2):
            j = os.path.join(res_dir, f"anchor-rev{k}.jsonl")
            if os.path.exists(j):
                os.unlink(j)
            tstree.run_units(tree, units, j, log, timeout=2400)
            runs.append(tstree.parse(j)[0])
        both = {t for t in failing if all(tstree.case_status(x, t) == "fail" for x in runs)}
        out["anchor_cases"] = sorted(both & passing_fix)
        out["fail_reversed_any_release_case"] = len(both)
        # Normalised comparison (keys), for titles renamed since the fix.
        keys = lambda r, st: {case_key(t) for t, v in r.items() if v == st and not t.startswith("suite:")}
        k_pass = keys(at_fix, "pass")
        k_fail = keys(runs[0], "fail") & keys(runs[1], "fail")
        k_rel = {case_key(t) for t in failing}
        out["anchor_keys"] = sorted(k_pass & k_fail & k_rel)
        out["status"] = "exact" if out["anchor_cases"] else ("exact_normalized" if out["anchor_keys"] else "not_exact")
        return out
    except Exception as e:
        out["status"] = "error"
        out["error"] = repr(e)[-1000:]
        return out
    finally:
        json.dump(out, open(os.path.join(res_dir, "anchor.json"), "w"), indent=1)
        tstree.rm_tree(os.path.join(W, "trees", f"anchor-{short}"))


if __name__ == "__main__":
    from concurrent.futures import ThreadPoolExecutor
    cands = {c["sha"]: c for c in map(json.loads, open(f"{W}/candidates.jsonl"))}
    with ThreadPoolExecutor(3) as ex:
        for d, r in zip(sys.argv[1:], ex.map(lambda d: anchor(d, cands), sys.argv[1:])):
            print(os.path.basename(d.rstrip("/")), json.dumps(r), flush=True)
