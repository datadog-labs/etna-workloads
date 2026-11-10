#!/usr/bin/env python3
"""Anchor adapted bugs at their original fix commit.

For each adapted bug that passed the gate:
  1. tree = the fix commit's source (git archive), configured as close to the base as the
     old configure allows (--debug-node; fallback: plain), built with the shared ccache
  2. the adapted bug's failing cases, as they exist at the fix commit, run twice: must pass
  3. reverse the fix's implementation hunks (parent code + fix tests), rebuild, run twice
  4. anchor = "exact" if some case that fails for the adapted bug also fails here (both runs)
     and passed at the fix; "none" otherwise; "build-fails" / "fix-fails" recorded honestly
The tree is deleted afterwards whatever the outcome.  Resumable.
"""
import argparse, json, os, re, shutil, subprocess, sys, time, traceback
import gate, nodetest, slot as S

W = S.W


def sh(cmd, cwd, log, env=None, timeout=None):
    with open(log, "ab") as f:
        f.write(f"\n$ {' '.join(cmd)}\n".encode())
        f.flush()  # header must precede the command's output in the log
        r = subprocess.run(cmd, cwd=cwd, stdout=f, stderr=subprocess.STDOUT, env=env, timeout=timeout)
    return r.returncode == 0


PY2_SIGNATURES = ("Missing parentheses in call to 'print'", "multiple exception types must be parenthesized",
                  "Please use either Python 2", "leading zeros in decimal integer literals")
SYSTEM_PY = "/usr/bin/python3"  # Debian's python3 ships a distutils shim; /usr/local/python does not


def gyp_ru_compat(tree, sub=("tools", "gyp")):
    """Old gyp opens files with mode 'rU' (removed in Python 3.11): rewrite to 'r'.
    Build tooling only; never lib/ or src/. Returns the number of files patched."""
    n = 0
    for dp, _, fs in os.walk(os.path.join(tree, *sub)):
        for fn in fs:
            if fn.endswith(".py"):
                fp = os.path.join(dp, fn)
                s = open(fp, errors="replace").read()
                s2 = re.sub(r"""(open\([^)]*?,\s*)(["'])rU\2""", r"\1\2r\2", s)
                if s2 != s:
                    open(fp, "w").write(s2)
                    n += 1
    return n


STD_HEADERS = " ".join(f"-include {h}" for h in ("cstdint", "utility", "limits", "memory", "string",
                                                 "algorithm", "stdexcept", "cstdio", "functional"))
CLANG_GCC_DIR = "--gcc-install-dir=/usr/lib/gcc/x86_64-linux-gnu/13"


def first_error(text):
    m = re.search(r"(?:error|Error): ([^\n]{0,160})", text)
    return m.group(1) if m else None


PYCOMPAT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "pycompat")
# (signature in the build log, what to add to the build environment)
COMPAT_STEPS = [
    # gcc 13 / clang 18 libstdc++ no longer include these transitively; old V8/Node relied on it
    ("#include <cstdint>", "cxx-include-std-headers"),
    ("is not a member of \u2018std\u2019", "cxx-include-std-headers"),
    ("unknown type name 'uint", "cxx-include-std-headers"),
    ("unknown type name 'int", "cxx-include-std-headers"),
    ("no member named '", "cxx-include-std-headers"),
    # clang emits libcalls for some std::atomic ops (e.g. __atomic_is_lock_free); link libatomic
    ("undefined reference to `__atomic", "link-libatomic"),
    ("cannot import name 'Mapping' from 'collections'", "py-collections-abc-aliases"),
    ("cannot import name 'MutableMapping' from 'collections'", "py-collections-abc-aliases"),
]


def apply_compat(env, step):
    if step == "cxx-include-std-headers":
        # gyp builds V8's host-toolset objects (mksnapshot, torque) with CXXFLAGS_host
        for var in ("CXXFLAGS", "CXXFLAGS_host"):
            env[var] = (env.get(var, "") + " " + STD_HEADERS).strip()
    elif step == "link-libatomic":
        for var in ("LDFLAGS", "LDFLAGS_host"):
            env[var] = (env.get(var, "") + " -latomic").strip()
    elif step == "py-collections-abc-aliases":
        env["PYTHONPATH"] = PYCOMPAT + (":" + env["PYTHONPATH"] if env.get("PYTHONPATH") else "")


def make_with_compat(tree, log, env, info, target=()):
    """make; on a known toolchain-compatibility failure, add the matching build-environment
    workaround (compiler flag / Python shim; never lib/ or src/) and retry. Records what was used."""
    used = info.setdefault("compat_env", [])
    for _ in range(len(COMPAT_STEPS) + 1):
        pos = os.path.getsize(log) if os.path.exists(log) else 0
        if sh(["make", "-j16", *target], tree, log, env, timeout=4 * 3600):
            return True
        with open(log, errors="replace") as f:
            f.seek(pos)
            new = f.read()
        step = next((st for sig, st in COMPAT_STEPS if sig in new and st not in used), None)
        if not step:
            return False
        used.append(step)
        apply_compat(env, step)
    return False


COMPAT_VERSION = 6  # bump when the compat steps change; recorded per anchor


def build_tree(tree, log, need_cc, need_addons, info):
    info["compat_version"] = COMPAT_VERSION
    env = dict(os.environ, **S.CCACHE_ENV, CC="ccache gcc", CXX="ccache g++",
               PATH="/usr/bin:/bin:" + os.environ["PATH"],
               # collections ABC aliases for old gyp/jinja2 (configure and build)
               PYTHONPATH=PYCOMPAT)
    cfg = "configure.py" if os.path.exists(os.path.join(tree, "configure.py")) else "configure"
    head = open(os.path.join(tree, cfg), errors="replace").read()
    if re.search(r"^\s*print [^(=]", head, re.M):
        return "configure-needs-python2"
    if "--debug-node" in head:
        info["configure"] = "--debug-node"
        args = ["--debug-node"]
    else:
        info["configure"] = "plain (this revision has no --debug-node)"
        args = []
    if not sh([SYSTEM_PY, cfg, *args], tree, log, env):
        tail5k = open(log, errors="replace").read()[-5000:]
        if any(sig in tail5k for sig in PY2_SIGNATURES):
            return "configure-needs-python2"
        if "'rU'" in open(log, errors="replace").read()[-5000:]:
            info["compat"] = f"gyp 'rU' -> 'r' in {gyp_ru_compat(tree)} files"
            if not sh([SYSTEM_PY, cfg, *args], tree, log, env):
                return "configure-fails"
        else:
            return "configure-fails"
    if not make_with_compat(tree, log, env, info):
        # Compiler compatibility: old V8 often fails with gcc 13 (stricter headers/traits) but
        # was developed against clang; retry the whole build once with clang (recorded).
        info["compiler"] = "clang (gcc 13 failed)"
        info["gcc_compat_env"] = info.pop("compat_env", [])
        info["gcc_error"] = first_error(open(log, errors="replace").read())
        sh(["make", "clean"], tree, log, env)
        # clang 18 picks /usr/lib/gcc/x86_64-linux-gnu/14, which has no libstdc++ headers here
        env = dict(env, CC=f"ccache clang {CLANG_GCC_DIR}", CXX=f"ccache clang++ {CLANG_GCC_DIR}")
        # clang >= 16 makes this an error by default; 2021-era V8 (bit-field.h) trips it
        for var in ("CXXFLAGS", "CXXFLAGS_host"):
            env[var] = (env.get(var, "") + " -Wno-enum-constexpr-conversion").strip()
        # keep CXXFLAGS (e.g. the std header bundle) for clang too
        ok = sh([SYSTEM_PY, cfg, *args], tree, log, env)
        if not ok and "new enough assembler" in open(log, errors="replace").read()[-3000:]:
            # old configure cannot detect clang's integrated assembler; documented workaround
            info["configure_clang"] = "--openssl-no-asm"
            ok = sh([SYSTEM_PY, cfg, *args, "--openssl-no-asm"], tree, log, env)
        if not ok:
            return "configure-fails(clang)"
        if not make_with_compat(tree, log, env, info):
            return "build-fails"
    else:
        info["compiler"] = "gcc"
    info["_env"] = env
    if need_cc and not sh(["make", "-j16", "-C", "out", "BUILDTYPE=Release", "cctest"], tree, log, env):
        return "build-fails(cctest)"
    if need_addons:
        # only targets this revision's Makefile has (build-ffi-tests is from 2026)
        mk = open(os.path.join(tree, "Makefile"), errors="replace").read()
        targets = [t for t in ("build-ffi-tests", "build-addons", "build-js-native-api-tests",
                               "build-node-api-tests") if re.search(rf"^{t}:", mk, re.M)]
        # node-gyp bundles its own gyp copy, which also opens files with mode 'rU'
        n = gyp_ru_compat(tree, ("deps", "npm", "node_modules", "node-gyp", "gyp"))
        if n:
            info["compat_addons"] = f"node-gyp gyp 'rU' -> 'r' in {n} files"
        if targets and not sh(["make", "-j16", *targets], tree, log, env):
            return "build-fails(addons)"
    return None


def run_cases(tree, cases, scratch):
    js = [c for c in cases if not c.startswith("cctest:")]
    cc = [c for c in cases if c.startswith("cctest:")]
    units = sorted({gate.unit_of(c) for c in js})
    runs = []
    for _ in range(2):
        r, _ = nodetest.run_js(tree, os.path.join(tree, "out/Release/node"), units, jobs=4, scratch=scratch)
        rc, _ = nodetest.run_cctest(tree, cc)
        runs.append({**r, **rc})
    return runs


def anchor_one(bug, cand, args):
    import memwatch
    memwatch.require()
    sha = bug["sha"]
    out = {"sha": sha, "t0": time.time()}
    failing = bug["gate"]["failing"]
    out["adapted_failing"] = failing
    tree = os.path.join(W, "anchor", sha[:12])
    log = os.path.join(W, "logs", f"anchor-{sha[:12]}.log")
    if os.path.exists(log):
        os.replace(log, log + ".prev")  # each run gets a fresh log (stale errors misled gcc_error)
    shutil.rmtree(tree, ignore_errors=True)
    os.makedirs(tree)
    try:
        p1 = subprocess.Popen(["git", "-C", gate.REPO, "archive", sha], stdout=subprocess.PIPE)
        subprocess.run(["tar", "-x", "-C", tree], stdin=p1.stdout, check=True)
        p1.wait()
        need_cc = any(c.startswith("cctest:") for c in failing)
        need_addons = any(c.split("/")[0] in nodetest.ADDON_SUITES | {"ffi"} for c in failing)
        t = time.time()
        err = build_tree(tree, log, need_cc, need_addons, out)
        out["build_s"] = round(time.time() - t)
        if err:
            out["anchor"] = err
            out["log_tail"] = open(log, errors="replace").read()[-3000:] if os.path.exists(log) else ""
            return out
        scratch = os.path.join(W, "tmp")
        fix_runs = run_cases(tree, failing, scratch)
        passing_at_fix = [c for c in failing if all(r.get(c) == "pass" for r in fix_runs)]
        out["fix_runs"] = fix_runs
        out["passing_at_fix"] = passing_at_fix
        if not passing_at_fix:
            missing = all(r.get(c) in (None, "missing") for r in fix_runs for c in failing)
            out["anchor"] = "cases-missing-at-fix" if missing else "fix-fails"
            return out
        d = gate.impl_diff(cand)
        if S.apply(tree, d, reverse=True, fuzz=False) is None:
            out["anchor"] = "reverse-does-not-apply"
            return out
        env = out.pop("_env")
        if not make_with_compat(tree, log, env, out) or \
                (need_cc and not sh(["make", "-j16", "-C", "out", "BUILDTYPE=Release", "cctest"], tree, log, env)):
            out["anchor"] = "parent-build-fails"
            return out
        par_runs = run_cases(tree, passing_at_fix, scratch)
        out["parent_runs"] = par_runs
        fail_par = [c for c in passing_at_fix
                    if all(r.get(c) in ("fail", "crash", "timeout") for r in par_runs)]
        out["failing_at_parent"] = fail_par
        out["anchor"] = "exact" if fail_par else "none"
        return out
    finally:
        out.pop("_env", None)  # never store the build environment (it holds credentials)
        shutil.rmtree(tree, ignore_errors=True)
        out["secs"] = round(time.time() - out.pop("t0"))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--adapted", required=True, nargs="+")
    ap.add_argument("--cands", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--limit", type=int)
    ap.add_argument("--only", help="file with shas to anchor")
    a = ap.parse_args()
    cands = {json.loads(l)["sha"]: json.loads(l) for l in open(a.cands)}
    done = set()
    if os.path.exists(a.out):
        done = {json.loads(l)["sha"] for l in open(a.out)}
    bugs = [json.loads(l) for f in a.adapted if os.path.exists(f) for l in open(f)]
    bugs = [b for b in bugs if b["status"] == "pass" and b["sha"] not in done]
    # Bugs that can become strict (a failing case was added by the fix) first, newest first.
    bugs.sort(key=lambda b: (not b["gate"].get("added_failing"), [-ord(ch) for ch in b["date"]]))
    if a.only:
        want = set(open(a.only).read().split())
        bugs = [b for b in bugs if b["sha"] in want]
    if a.limit:
        bugs = bugs[:a.limit]
    print(f"anchor todo: {len(bugs)}", flush=True)
    streak = []  # circuit breaker: fast identical failures mean a tooling fault, not commits
    for b in bugs:
        try:
            r = anchor_one(b, cands[b["sha"]], a)
        except Exception:
            r = {"sha": b["sha"], "anchor": "error", "error": traceback.format_exc()[-3000:]}
        with open(a.out, "a") as f:
            f.write(json.dumps(r) + "\n")
        print(f"{b['sha'][:10]} anchor={r['anchor']:20} build={r.get('build_s')}s {b['subject'][:60]}", flush=True)
        # known environment limits are honest results, not tooling faults
        failed = r["anchor"] not in ("exact", "none", "configure-needs-python2")
        key = (r["anchor"], (r.get("secs") or 0) < 60,
               re.sub(r"[‘'][^’']*[’']", "X", first_error(r.get("log_tail") or "") or ""))
        streak = streak + [key] if failed else []
        if len(streak) >= 5 and len(set(streak[-5:])) == 1:
            print(f"CIRCUIT BREAKER: 5 consecutive identical failures {key}; stopping (tooling fault?)",
                  flush=True)
            sys.exit(3)


if __name__ == "__main__":
    main()
