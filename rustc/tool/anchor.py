#!/usr/bin/env python3
"""Anchor check for adapted bugs.

At the original fix commit C: the fix's implementation reversed (= the
parent's code) with the fix's tests.  Build it and run the fix's test cases
twice.  The anchor is "exact" if some failing case is also a failing case of
the adapted injection on the release (cases mapped through renames).

LLVM: CI LLVM if still downloadable for C, else the system LLVM 20
(llvm-config-20) if that rustc accepts it; otherwise "anchor_build_failed".

usage: anchor.py [--slot a0] [--only C...]     results: data/anchor/<commit>.json
"""
import argparse
import fcntl
import re
import shutil
import json
import os
import subprocess
import sys
import time

sys.path.insert(0, os.path.dirname(__file__))
from common import DATA, WORK, InfraError, git, is_impl, is_test_only_impl, save_result, test_suite  # noqa: E402
import llvm_build  # noqa: E402
import memguard  # noqa: E402
import runner  # noqa: E402

OUT = os.path.join(DATA, "anchor")
ANCHORS = os.path.join(WORK, "anchors")
BASECFG = """profile = "compiler"
change-id = "ignore"
[build]
compiler-docs = false
docs = false
extended = false
[rust]
debug-assertions = true
debug-logging = true
incremental = true
verbose-tests = true
download-rustc = false
deny-warnings = false
[llvm]
"""
CI_CUTOFF = "2026-04-15"
CI_LLVM = 'download-ci-llvm = true\nassertions = false\n'
EXT_LLVM = ('download-ci-llvm = false\n[target.x86_64-unknown-linux-gnu]\n'
            'llvm-config = "{cfg}"\nllvm-filecheck = "{fc}"\n')


def sh(cmd, cwd, **kw):
    return subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, **kw)


def wipe_build(tree):
    """Remove everything under build/ except build/cache (downloaded tarballs).
    Bootstrap state reused across far-apart revisions breaks old builds (cargo
    asked for `cargo clean`: 28 anchors failed with "cannot find attribute serde")."""
    b = os.path.join(tree, "build")
    if os.path.isdir(b):
        for e in os.listdir(b):
            if e != "cache":
                p = os.path.join(b, e)
                shutil.rmtree(p, ignore_errors=True) if os.path.isdir(p) else os.unlink(p)


def is_test_path(p):
    return bool(test_suite(p)) or is_test_only_impl(p) or p.startswith(("tests/", "src/test/"))


def gitlinks_at(rev):
    """{path: commit} of the submodule pointers at rev."""
    out = git("ls-tree", "-r", rev)
    return {line.split("\t")[1]: line.split()[2] for line in out.splitlines() if line.startswith("160000")}


def needed_submodules(h, links):
    """Submodules the build needs: std's arch/backtrace code and every gitlink that is a
    member of the root Cargo workspace (early-2023 trees: src/tools/rust-installer;
    11 anchors failed with `failed to load manifest ... rust-installer`)."""
    cargo = git("show", f"{h}:Cargo.toml", check=False)
    ws = cargo.split("[workspace]", 1)[1].split("\n[", 1)[0] if "[workspace]" in cargo else ""
    members = set(re.findall(r'"([^"]+)"', ws))
    return sorted(p for p in links if p in members or p in ("library/stdarch", "library/backtrace"))


def empty_dir(p):
    if os.path.isdir(p) and not os.path.islink(p):
        for e in os.listdir(p):
            q = os.path.join(p, e)
            shutil.rmtree(q) if os.path.isdir(q) and not os.path.islink(q) else os.unlink(q)


def prepare(tree, h):
    if not os.path.exists(tree):
        git("worktree", "add", "--detach", tree, h)
    wipe_build(tree)
    # Submodule directories of the previous revision may hold checkouts or leftovers that
    # git leaves alone; empty them so nothing carries over between anchors.
    head = sh(["git", "rev-parse", "HEAD"], tree).stdout.strip()
    for p in gitlinks_at(head) if head else {}:
        empty_dir(os.path.join(tree, p))
    # On a branch, not detached: early-2024 bootstraps run `git symbolic-ref HEAD` when they
    # update submodules and fail on a detached HEAD (3 anchors failed that way).
    r = sh(["git", "checkout", "-q", "-f", "-B", "etna-" + os.path.basename(tree), h], tree)
    if r.returncode:
        raise RuntimeError(r.stderr)
    sh(["git", "clean", "-qffdx", "-e", "build", "-e", "bootstrap.toml", "-e", "config.toml"], tree)
    links = gitlinks_at(h)
    need = needed_submodules(h, links)
    for p in links:
        if p not in need:
            empty_dir(os.path.join(tree, p))
    if need:
        r = sh(["git", "submodule", "update", "--init", "--force", "--checkout", "--depth", "1", "--", *need], tree)
        if r.returncode:
            raise RuntimeError("submodule update failed: " + r.stderr[-500:])
        for m in need:
            sh(["git", "reset", "-q", "--hard"], os.path.join(tree, m))
            sh(["git", "clean", "-qffdx"], os.path.join(tree, m))
            got = sh(["git", "rev-parse", "HEAD"], os.path.join(tree, m)).stdout.strip()
            if got != links[m]:
                raise RuntimeError(f"submodule {m} at {got[:10]}, expected {links[m][:10]}")
        st = sh(["git", "status", "--porcelain", "--", *need], tree).stdout
        if st.strip():
            raise RuntimeError("submodules not clean: " + st[:300])
    # The parent's code with the fix's tests: reverse every non-test file the fix
    # changed (compiler/ and also library/, src/...; a compiler-only reversal cannot
    # build std when the fix spans both), except submodule pointers.
    files = [p for p in git("diff", "--name-only", "--no-renames", f"{h}^", h).split()
             if not is_test_path(p) and p not in links]
    fix = git("diff", "--no-renames", "--full-index", "--binary", f"{h}^", h, "--", *files)
    r = subprocess.run(["git", "apply", "-R"], cwd=tree, input=fix, capture_output=True, text=True)
    if r.returncode:
        raise RuntimeError("fix does not reverse at its own commit: " + r.stderr[:500])
    return dict(reversed=files, submodules=need)


def change_id_line(tree):
    """A change-id value this tree's bootstrap accepts (old ones reject "ignore").
    The change history moved around inside src/bootstrap over time; search for it."""
    for root, _dirs, files in os.walk(os.path.join(tree, "src/bootstrap")):
        for f in files:
            if not f.endswith(".rs"):
                continue
            text = open(os.path.join(root, f), errors="replace").read()
            if "CONFIG_CHANGE_HISTORY" not in text:
                continue
            if "ChangeId::Ignore" in text or '"ignore"' in text:
                return 'change-id = "ignore"'
            ids = [int(x) for x in re.findall(r"change_id:\s*(\d+)", text)]
            m = re.search(r"CONFIG_CHANGE_HISTORY:\s*&\[usize\]\s*=\s*&\[([\d,\s_]*)\]", text)
            if m:  # 2023 form: a plain array; the id must be one of its entries
                ids += [int(x.replace("_", "")) for x in re.findall(r"[\d_]+", m.group(1))]
            if ids:
                return f"change-id = {max(ids)}"
    for cfgrs in ("src/bootstrap/src/core/config/config.rs", "src/bootstrap/config.rs"):
        p = os.path.join(tree, cfgrs)
        if os.path.exists(p) and "changelog-seen" in open(p, errors="replace").read():
            return "changelog-seen = 2"
    return ""


def configure(tree, llvm, ext=None, strip=()):
    cfg = BASECFG.replace('change-id = "ignore"', change_id_line(tree))
    cfg += CI_LLVM if llvm == "ci" else EXT_LLVM.format(cfg=ext[0], fc=ext[1])
    for key in strip:  # keys older bootstraps reject
        cfg = "\n".join(line for line in cfg.splitlines() if not line.startswith(key)) + "\n"
    for name in ("bootstrap.toml", "config.toml"):  # older trees read config.toml
        open(os.path.join(tree, name), "w").write(cfg)


PYCOMPAT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "pycompat")


class NeedsOldPython(Exception):
    pass


def python_env(tree):
    """(env, note) for running this tree's x.py with today's python3 (3.12).
    Old bootstraps import distutils (removed in 3.12): when the import is present but
    unused, a shim makes it importable; when it is used, the tree needs an old Python."""
    bs = os.path.join(tree, "src/bootstrap/bootstrap.py")
    text = open(bs, errors="replace").read() if os.path.exists(bs) else ""
    if not re.search(r"^\s*(import distutils|from distutils)", text, re.M):
        return None, None
    uses = [line for line in text.splitlines()
            if "distutils" in line and not re.match(r"\s*(import|from)\s+distutils", line)]
    if uses:
        raise NeedsOldPython("bootstrap.py uses distutils: " + uses[0].strip()[:200])
    env = dict(os.environ, PYTHONPATH=PYCOMPAT + os.pathsep + os.environ.get("PYTHONPATH", ""))
    return env, "distutils-shim (bootstrap.py imports distutils.version but does not use it)"


def build(tree, log, env=None):
    with runner.build_permit("anchor", 4):
        return runner.run(["python3", "x.py", "build", "--stage", "1", "library"], tree, log, 10800,
                          env=env, kind="anchor_build")


CONFIG_ERR = re.compile(r"(?:failed to parse|Failed to parse)[^\n]*", re.I)


def rejected_keys(tail):
    keys = set(re.findall(r"unknown field `([\w-]+)`", tail)) | set(re.findall(r"for key `([\w.-]+)`", tail))
    keys = {k.split(".")[-1].replace("_", "-") for k in keys}
    if not keys and CONFIG_ERR.search(tail) and 'string "ignore"' in tail:
        keys = {"change-id"}
    return keys


def try_build(tree, log, llvm, ext=None, env=None):
    strip = set()
    for _ in range(4):
        configure(tree, llvm, ext, strip)
        code, secs = build(tree, log, env)
        if code == 0:
            return code, secs
        tail = open(log, errors="replace").read()[-6000:]
        bad = rejected_keys(tail) - strip
        if not bad:
            return code, secs
        strip |= bad
    return code, secs


def anchor_one(r, tm, slot):
    """One anchor in tree `slot`, holding the tree's exclusive lock (two workers once
    shared a tree: one checked out a new commit under the other's test run)."""
    os.makedirs(ANCHORS, exist_ok=True)
    with open(os.path.join(ANCHORS, f".{slot}.lock"), "w") as lk:
        try:
            fcntl.flock(lk, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            raise InfraError(f"anchor tree {slot} is in use by another worker")
        return _anchor_one(r, tm, slot)


def _anchor_one(r, tm, slot):
    h = r["commit"]
    tree = os.path.join(ANCHORS, slot)
    os.makedirs(ANCHORS, exist_ok=True)
    res = dict(commit=h, t=time.time())
    prep = prepare(tree, h)
    res["reversed_files"], res["submodules"] = prep["reversed"], prep["submodules"]
    try:
        env, note = python_env(tree)
    except NeedsOldPython as e:
        res.update(status="needs_old_python", error=str(e))
        return res
    if note:
        res["python_compat"] = note
    # Fix-time paths of the adapted injection's failing cases.
    rel2fix = {e["release_path"]: e["fix_path"] for e in tm["cases"] if e["release_path"]}
    failing_rel = r["gate"]["failing"]
    want = {}
    for k in failing_rel:
        f, _, rev = k.partition("#")
        if f in rel2fix:
            want[rel2fix[f] + (("#" + rev) if rev else "")] = k
    all_fix_files = sorted({e["fix_path"] for e in tm["cases"] if e["oracle_suite"]})
    res["fix_case_files"] = all_fix_files
    log = os.path.join(ANCHORS, f"{slot}-build.log")
    # CI LLVM artifacts expire after ~5 months (404 measured for 2026-04-01 and older).
    date = git("log", "-1", "--format=%cs", h).strip()
    for llvm in (("ci", "external") if date >= CI_CUTOFF else ("external",)):
        ext = None
        if llvm == "external":
            try:
                cfg, fc, desc = llvm_build.llvm_config_for(h)
            except Exception as e:  # noqa: BLE001
                res.setdefault("builds", []).append(dict(llvm="external", error=repr(e)[:500]))
                break
            ext, llvm = (cfg, fc), desc
        code, secs = try_build(tree, log, "ci" if llvm == "ci" else "ext", ext, env)
        res.setdefault("builds", []).append(dict(llvm=llvm, exit=code, secs=round(secs)))
        if code == 0:
            res["llvm"] = llvm
            break
        if llvm == "ci":
            tail = open(log, errors="replace").read()[-8000:]
            if re.search(r"error\[E\d+\]|could not compile `(?!rustc_llvm)", tail) and not re.search(
                    r"rust-dev|ci-llvm|download-ci-llvm|404", tail):
                break  # the tree's own code does not build; another LLVM would not help
    if not res.get("llvm"):
        res["status"] = "anchor_build_failed"
        res["build_tail"] = open(log, errors="replace").read()[-2500:]
        return res
    runs = []
    for i in (1, 2):
        # tests: suite paths at C may be src/test/... (old layout); runner filters missing paths
        code, secs, cases, _ = runner.test(tree, all_fix_files, os.path.join(ANCHORS, f"{slot}-t{i}.log"),
                                           xcmd=["python3", "x.py"], env=env)
        runs.append(cases)
    failing = sorted(k for k in runs[0] if all(rr.get(k) in ("failed", "timeout") for rr in runs))
    res["anchor_failing"] = failing
    res["anchor_cases"] = runs[0]

    def norm(k):  # old compiletest may print paths relative to the suite root
        f, _, rev = k.partition("#")
        f = f.replace("src/test/", "tests/", 1)
        return (f[len("tests/"):] if f.startswith("tests/") else f), rev

    def same(k, w):
        (f1, r1), (f2, r2) = norm(k), norm(w)
        return r1 == r2 and (f1 == f2 or f1.endswith("/" + f2) or f2.endswith("/" + f1))

    shared = sorted({rel for k in failing for w, rel in want.items() if same(k, w)})
    res["shared_failing"] = shared
    res["status"] = "exact" if shared else ("anchor_fails_other" if failing else "anchor_no_failure")
    return res


def clean_tree(slot):
    """Old-revision builds are not reused safely across far-apart commits and
    accumulate (one anchor tree reached 74 GB and the disk filled up): drop the
    per-target build output after every anchor; keep build/cache (downloads)."""
    wipe_build(os.path.join(ANCHORS, slot))


NET_ERR = re.compile(r"Could not resolve host|Temporary failure in name resolution|unable to access 'https://|"
                     r"EAI_AGAIN|Network is unreachable|Connection timed out|Failed to connect")


def network_ok():
    import socket
    try:
        socket.getaddrinfo("github.com", 443)
        return True
    except OSError:
        return False


def wait_for_network():
    warned = False
    while not network_ok():
        if not warned:
            print("network down (github.com does not resolve): waiting", flush=True)
            warned = True
        time.sleep(60)


FAST_FAIL_SECS = 60
FAST_FAIL_STREAK = 3


def fast_fail_signature(res):
    """Signature of a build failure that is too fast to be a real compile error (the tree's
    tooling failed before compiling: e.g. 48 old bootstraps died on `import distutils`)."""
    if res.get("status") not in ("anchor_build_failed", "needs_old_python"):
        return None
    if sum(b.get("secs") or 0 for b in res.get("builds", [])) >= FAST_FAIL_SECS:
        return None
    lines = [x for x in (res.get("build_tail") or res.get("error") or "").splitlines() if x.strip()]
    last = lines[-1] if lines else ""
    return re.sub(r"/home/\S+|\b[0-9a-f]{7,40}\b|\d+", "N", last)[:200]


def claim(h):
    try:
        os.close(os.open(os.path.join(OUT, h + ".claim"), os.O_CREAT | os.O_EXCL | os.O_WRONLY))
        return True
    except FileExistsError:
        return False


def pending(only):
    ad = os.path.join(DATA, "adapted")
    todo = []
    for f in sorted(os.listdir(ad)):
        if f.endswith(".json"):
            r = json.load(open(os.path.join(ad, f)))
            h = r["commit"]
            if (r["status"] == "gate_pass" and not os.path.exists(os.path.join(OUT, h + ".json"))
                    and not os.path.exists(os.path.join(OUT, h + ".claim"))):
                if not only or any(h.startswith(x) for x in only):
                    todo.append(r)
    todo.sort(key=lambda r: r["date"], reverse=True)
    return todo


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--slot", default="a0")
    ap.add_argument("--only", nargs="*")
    ap.add_argument("--watch", help="keep polling until this file exists")
    a = ap.parse_args()
    os.makedirs(OUT, exist_ok=True)
    tms = {json.loads(line)["commit"]: json.loads(line) for line in open(os.path.join(DATA, "testmap.jsonl"))}
    errors = 0
    streak, streak_sig = [], None
    while True:
        todo = pending(a.only)
        if not todo:
            if a.watch and not os.path.exists(a.watch):
                time.sleep(120)
                continue
            break
        r = todo[0]
        if not claim(r["commit"]):
            continue
        t = time.time()
        try:
            res = anchor_one(r, tms[r["commit"]], a.slot)
        except InfraError as e:  # memory watchdog gave up on a job: not a result
            clean_tree(a.slot)
            os.unlink(os.path.join(OUT, r["commit"] + ".claim"))
            print(f"INFRA ERROR, anchor worker stops: {e}", flush=True)
            sys.exit(3)
        except Exception as e:  # noqa: BLE001
            res = dict(commit=r["commit"], status="anchor_error", error=repr(e)[:2000])
        res["secs"] = round(time.time() - t)
        clean_tree(a.slot)
        os.unlink(os.path.join(OUT, r["commit"] + ".claim"))
        # Infrastructure failures are never results: a network error is retried once the
        # network is back (the host once lost DNS and 907 anchors were recorded as errors);
        # a build that hit its timeout means the host was overloaded.
        if res["status"] == "anchor_error" and NET_ERR.search(res.get("error", "")):
            print(f"{r['commit'][:10]} network error, not recorded: {res['error'][:120]}", flush=True)
            wait_for_network()
            continue
        if any(b.get("exit") == "timeout" for b in res.get("builds", [])):
            print(f"{r['commit'][:10]} build timed out (host overloaded?), not recorded", flush=True)
            memguard.wait_for_memory(memguard.GB["anchor_build"], "anchor")
            continue
        sig = fast_fail_signature(res)
        streak = (streak + [r["commit"]]) if sig and sig == streak_sig else ([r["commit"]] if sig else [])
        streak_sig = sig
        if len(streak) >= FAST_FAIL_STREAK:
            # Identical fast failures are a tooling problem, not results: take the streak's
            # earlier records back out and stop this worker.
            d = os.path.join(DATA, "infra-errors", "anchor")
            os.makedirs(d, exist_ok=True)
            for c in streak[:-1]:
                p = os.path.join(OUT, c + ".json")
                if os.path.exists(p):
                    shutil.move(p, os.path.join(d, c + ".json"))
            json.dump(res, open(os.path.join(d, r["commit"] + ".json"), "w"), indent=1)
            print(f"INFRA ERROR, anchor worker stops: {len(streak)} identical fast build failures "
                  f"({sig!r}); records moved to {d}", flush=True)
            sys.exit(3)
        errors = errors + 1 if res["status"] == "anchor_error" else 0
        if errors >= 5:
            print(f"INFRA ERROR, anchor worker stops: 5 consecutive anchor_error, last: {res['error'][:300]}",
                  flush=True)
            sys.exit(3)
        try:
            save_result(os.path.join(OUT, r["commit"] + ".json"), res)
        except InfraError as e:
            print(f"INFRA ERROR, anchor worker stops: {e}", flush=True)
            sys.exit(3)
        print(f"{r['commit'][:10]} {r['date'][:10]} {res['status']:<20} llvm={res.get('llvm')} "
              f"shared={len(res.get('shared_failing', []))} {res['secs']}s", flush=True)


if __name__ == "__main__":
    main()
