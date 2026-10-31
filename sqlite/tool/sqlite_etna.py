#!/usr/bin/env python3
"""Frontport SQLite's historical bug fixes onto a release, etna-style.

A candidate is a non-merge commit reachable from the target release that
changes implementation (src/, ext/) and tests, and whose message reads as a
fix. Its *oracle* is the set of test cases the fix added or changed
(do_*test NAME in test/*.test), as they exist, unchanged, in the target
release, restricted to those that pass there. An *injection* is a change to
the target's implementation files that makes at least one oracle case fail.

Stages (each appends to state/<stage>.jsonl; the latest record per id wins):

  mine      candidates.jsonl: commit, date, subject, report refs, files,
            added test names (literal names that still exist in the target)
  base      build testfixture at the target; run every test file any
            candidate needs; per file the cases that pass (base-runs.jsonl)
  verbatim  per candidate: the reverse of the fix's implementation hunks,
            applied exactly or with fuzz; build; run the oracle files.
            confirmed = applies, builds, some oracle case fails, and
            reversing the stored injection restores the base byte for byte.

Usage:
  sqlite_etna.py mine
  sqlite_etna.py base [-j N]
  sqlite_etna.py verbatim [-j N] [--limit K] [--ids a,b]
  sqlite_etna.py report
"""

import argparse
import filecmp
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import threading
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

ROOT = Path(os.environ.get("ETNA_ROOT", Path(__file__).resolve().parent.parent))
SRC = Path(os.environ.get("ETNA_SRC", os.environ.get("SQLITE_SRC", ROOT / "sqlite-src")))
TARGET = os.environ.get("ETNA_TARGET", "version-3.54.1")
STATE = ROOT / "state"
DATASET = ROOT / "dataset"
# Scratch on the main disk: the workspace's /tmp is a 32 GB tmpfs.
WORK = Path(os.environ.get("ETNA_WORK", Path.home() / "sqlite-etna-work"))
TEST_TIMEOUT = int(os.environ.get("ETNA_TEST_TIMEOUT", "900"))

# --debug: assert()s are on, so assertion-fault fixes have an oracle too.
# -O0: the amalgamation compiles in about half the time of the default -O2,
# and the tests run about as fast.
CONFIGURE = ["./configure", "--all", "--geopoly", "--session", "--debug", "CFLAGS=-g -O0"]
# Trees before autosetup (2024-11-06) have an autoconf configure: the same
# build expressed as its options, tried in order (very old ones lack some).
LEGACY_DEFS = ("-g -O0 -DSQLITE_DEBUG=1 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS "
               "-DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_GEOPOLY "
               "-DSQLITE_ENABLE_SESSION -DSQLITE_ENABLE_PREUPDATE_HOOK")
LEGACY_DEFS += " -DUSE_INTERP_RESULT"     # Tcl 8.6 dropped interp->result (pre-2008 tclsqlite.c)
LEGACY_CONFIGURES = [
    ["./configure", "--enable-debug", "--with-tcl=/usr/lib/tcl8.6", f"CFLAGS={LEGACY_DEFS}", "LIBS=-lm"],
    ["./configure", "--with-tcl=/usr/lib/tcl8.6", f"CFLAGS={LEGACY_DEFS}", "LIBS=-lm"],
    # The oldest trees: K&R C (lemon.c) that gcc 13 rejects in its default mode.
    ["./configure", "--with-tcl=/usr/lib/tcl8.6", f"CFLAGS={LEGACY_DEFS} -std=gnu89 -fcommon",
     "LIBS=-lm", "BCC=gcc -std=gnu89 -g"],
]

IMPL = re.compile(r"^(src|ext)/.*\.(c|h|y|in)$")
NOT_IMPL = re.compile(r"(/test[^/]*\.c$|^src/test_|^src/tclsqlite|fts5_test_|^ext/wasm/|^ext/jni/|"
                      r"^ext/lsm1/|^ext/repair/test|/tool/|^src/shell)")
TESTFILE = re.compile(r"^(test|ext/[^/]+(/[^/]+)?/test)/[^/]+\.test$")
FIXWORD = re.compile(r"ticket|\bbugs?\b|forum|\bfix|crash|assert|incorrect|wrong|segfault|overflow|"
                     r"corrupt|problem|error|fault|leak|uninitiali", re.I)
# do_test, do_execsql_test, do_catchsql_test, do_eqp_test, do_faultsim_test ...
TESTCASE = re.compile(r"^\+\s*(do_[a-z0-9_]*test[a-z0-9_]*)\s+([^\s{}\[\]$\\\"]+)\s")
NAME = "SQLite"
IMPL_DESC = "src/ and ext/"
MINE_MERGES = False   # also mine first-parent merge commits (targets whose PRs split code and tests)


def testcase_name(m):
    return m.group(2)


def is_fix(c, body):
    """Whether a candidate commit reads as a bug fix (targets may widen this)."""
    return bool(FIXWORD.search(c["subject"] if not c.get("merge") else body))


REPORT = re.compile(r"(\[[0-9a-f]{10,}\]|bugs:/?info/[0-9TZ:.-]+|forum:/?(?:info|forumpost)/[0-9a-zA-Z:.-]+|"
                    r"ticket\s+\[?[0-9a-f]{10,})")


# ------------------------------------------------------------------ utils

def run(cmd, cwd=None, check=True, input=None, timeout=3600, env=None):
    r = subprocess.run(cmd, cwd=cwd, input=input, capture_output=True, text=True,
                       timeout=timeout, env=env, errors="replace")
    if check and r.returncode != 0:
        raise RuntimeError(f"{' '.join(map(str, cmd))} failed ({r.returncode}):\n"
                           f"{r.stdout[-2000:]}{r.stderr[-2000:]}")
    return r


def git(*args, check=True):
    return run(["git", "-C", str(SRC), *args], check=check)


_lock = threading.Lock()


def append(stage, rec):
    STATE.mkdir(parents=True, exist_ok=True)
    rec = {**rec, "at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())}
    with _lock, open(STATE / f"{stage}.jsonl", "a") as f:
        f.write(json.dumps(rec, sort_keys=True) + "\n")


def latest(stage, key="id"):
    out = {}
    p = STATE / f"{stage}.jsonl"
    if p.exists():
        for line in open(p):
            try:
                r = json.loads(line)
            except json.JSONDecodeError:
                continue          # a torn last line after a crash
            out[r[key]] = r
    return out


_auth_lock = threading.Lock()
AUTH_CHECK = os.environ.get("ETNA_AUTH_CHECK", "ddtool auth token rapid-ai-platform --datacenter us1.ddbuild.io")


def wait_for_auth():
    """Block until the Claude API credential helper works. On the workspace it
    stops working when its credential lapses (seen when nobody is connected
    for a while); agents started then fail with a 401 after minutes of
    retries. Waiting instead lets a run stall and resume by itself."""
    if not AUTH_CHECK:
        return
    with _auth_lock:
        waited = False
        while subprocess.run(AUTH_CHECK, shell=True, stdout=subprocess.DEVNULL,
                             stderr=subprocess.DEVNULL).returncode != 0:
            if not waited:
                print(f"{time.strftime('%FT%TZ', time.gmtime())} auth helper failing; waiting", flush=True)
                waited = True
            time.sleep(300)
        if waited:
            print(f"{time.strftime('%FT%TZ', time.gmtime())} auth helper back", flush=True)


def target_commit():
    return git("rev-parse", TARGET + "^{commit}").stdout.strip()


# ------------------------------------------------------------------- mine

def cmd_mine(a):
    tgt = target_commit()
    log = git("log", "--no-merges", "--format=@@%H%x09%cI%x09%s", "--name-only", tgt).stdout
    commits, cur = [], None
    for line in log.splitlines():
        if line.startswith("@@"):
            h, d, s = line[2:].split("\t", 2)
            cur = {"id": h, "date": d, "subject": s, "files": []}
            commits.append(cur)
        elif line:
            cur["files"].append(line)
    if MINE_MERGES:
        mlog = git("log", "--merges", "--first-parent", "--diff-merges=first-parent",
                   "--format=@@%H%x09%cI%x09%s", "--name-only", tgt).stdout
        for line in mlog.splitlines():
            if line.startswith("@@"):
                h, d, s = line[2:].split("\t", 2)
                cur = {"id": h, "date": d, "subject": s, "files": [], "merge": True}
                commits.append(cur)
            elif line:
                cur["files"].append(line)
    # Test files present in the target, and their text, for the name check.
    present = set(git("ls-tree", "-r", "--name-only", tgt).stdout.split())
    textcache = {}

    def target_text(f):
        if f not in textcache:
            textcache[f] = git("show", f"{tgt}:{f}").stdout if f in present else None
        return textcache[f]

    n = 0
    out = STATE / "candidates.jsonl"
    STATE.mkdir(parents=True, exist_ok=True)
    tmp = out.with_suffix(".tmp")
    with open(tmp, "w") as fo:
        for c in commits:
            impl = [f for f in c["files"] if IMPL.match(f) and not NOT_IMPL.search(f)]
            tests = [f for f in c["files"] if TESTFILE.match(f)]
            if not impl or not tests:
                continue
            body = git("log", "-1", "--format=%B", c["id"]).stdout
            if c.get("merge"):
                # "Merge pull request #123 from ...": the PR title is the next line.
                rest = [l.strip() for l in body.splitlines()[1:] if l.strip()]
                if rest:
                    c["subject"] = rest[0]
            if not is_fix(c, body):
                continue
            diff = git("diff", "-U0", f"{c['id']}^1", c["id"], "--", *tests).stdout
            added, curfile = {}, None
            for line in diff.splitlines():
                if line.startswith("+++ "):
                    curfile = line[6:] if line.startswith("+++ b/") else None
                    continue
                m = TESTCASE.match(line)
                if m and curfile:
                    added.setdefault(curfile, []).append(testcase_name(m))
            oracle = {}
            for f, names in added.items():
                t = target_text(f)
                if t is None:
                    continue
                keep = sorted({nm for nm in names if nm in t})
                if keep:
                    oracle[f] = keep
            rec = {"id": c["id"], "date": c["date"], "subject": c["subject"], "merge": bool(c.get("merge")),
                   "fossil": (re.search(r"FossilOrigin-Name: (\w+)", body) or [None, None])[1],
                   "reports": sorted(set(REPORT.findall(body))),
                   "impl_files": impl, "test_files": tests,
                   "added_tests": added, "oracle_candidates": oracle}
            fo.write(json.dumps(rec, sort_keys=True) + "\n")
            n += 1
    tmp.replace(out)
    have = sum(1 for _ in open(out))
    with_oracle = sum(1 for l in open(out) if json.loads(l)["oracle_candidates"])
    print(f"target {TARGET} {tgt[:12]}: {have} candidates, {with_oracle} with test names present in the target")


def candidates():
    return {r["id"]: r for r in map(json.loads, open(STATE / "candidates.jsonl"))}


# ------------------------------------------------------------------ build

def export_tree(ref, dest):
    if dest.exists():
        shutil.rmtree(dest)
    dest.mkdir(parents=True)
    arch = subprocess.Popen(["git", "-C", str(SRC), "archive", "--format=tar", ref], stdout=subprocess.PIPE)
    subprocess.run(["tar", "-x", "-C", str(dest)], stdin=arch.stdout, check=True)
    if arch.wait() != 0:
        raise RuntimeError(f"git archive {ref} failed")


def build_testfixture(src_tree, bdir, jobs=2):
    """Configure and build testfixture in a fresh copy of an unconfigured tree
    (configure records the tree's absolute path). Returns (path, seconds, log)."""
    t0 = time.time()
    if bdir.exists():
        shutil.rmtree(bdir)
    shutil.copytree(src_tree, bdir, symlinks=True)
    env = {**os.environ, "CC": "ccache gcc", "CCACHE_BASEDIR": str(bdir),
           "CCACHE_DIR": os.environ.get("CCACHE_DIR", str(WORK / "ccache"))}
    configures = [CONFIGURE] if (bdir / "autosetup").is_dir() else LEGACY_CONFIGURES
    log = ""
    for i, cfg in enumerate(configures):
        if i:
            run(["make", "distclean"], cwd=bdir, check=False, env=env)
        r1 = run(cfg, cwd=bdir, check=False, env=env)
        if r1.returncode:
            log = r1.stdout[-3000:] + r1.stderr[-3000:]
            continue
        r2 = run(["make", f"-j{jobs}", "testfixture"], cwd=bdir, check=False, env=env)
        if r2.returncode == 0 and (bdir / "testfixture").exists():
            break
        log = r2.stdout[-3000:] + r2.stderr[-3000:]
    else:
        return None, time.time() - t0, log
    return bdir / "testfixture", time.time() - t0, ""


OKLINE = re.compile(r"^(\S+)\.\.\. *Ok\s*$")
FAILS = re.compile(r"^!?\s*Failures on these tests:\s*(.*)$")
SUMMARY = re.compile(r"^(\d+) errors? out of (\d+) tests")


def run_testfile(testfixture, tree, testfile):
    """Run one test file in a scratch cwd. Returns dict(ok=[...], failed=[...],
    complete=bool, rc, seconds, tail)."""
    t0 = time.time()
    cwd = Path(tempfile.mkdtemp(prefix="tf-", dir=WORK))
    try:
        try:
            r = subprocess.run([str(testfixture), str(tree / testfile)], cwd=cwd,
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=TEST_TIMEOUT)
            out, rc, timeout = r.stdout.decode("utf-8", "replace"), r.returncode, False
        except subprocess.TimeoutExpired as e:
            out, rc, timeout = (e.stdout or b"").decode("utf-8", "replace"), None, True
    finally:
        shutil.rmtree(cwd, ignore_errors=True)
    ok, failed, complete = set(), set(), False
    for line in out.splitlines():
        m = OKLINE.match(line)
        if m:
            ok.add(m.group(1))
        m = FAILS.match(line)
        if m:
            failed |= set(m.group(1).split())
        if SUMMARY.match(line):
            complete = True
    return {"ok": sorted(ok - failed), "failed": sorted(failed), "complete": complete and not timeout,
            "rc": rc, "timeout": timeout, "seconds": round(time.time() - t0, 1),
            "tail": out[-1500:] if (failed or not complete) else ""}


def base_paths():
    return WORK / "base-src", WORK / "base-build" / "testfixture"


# ------------------------------------------------------------------- base

def cmd_base(a):
    tgt = target_commit()
    src, tf = base_paths()
    if not tf.exists():
        print(f"exporting and building {TARGET} {tgt[:12]}", flush=True)
        export_tree(tgt, src)
        built, secs, log = build_testfixture(src, WORK / "base-build", jobs=os.cpu_count() or 8)
        if not built:
            sys.exit(f"base build failed:\n{log}")
        print(f"base testfixture in {secs:.0f}s", flush=True)
    files = sorted({f for c in candidates().values() for f in c["test_files"] if (src / f).exists()})
    done = latest("base-runs", key="file")
    todo = [f for f in files if f not in done or done[f].get("target") != tgt]
    print(f"{len(files)} test files, {len(todo)} to run", flush=True)
    with ThreadPoolExecutor(a.j) as ex:
        futs = {ex.submit(run_testfile, tf, src, f): f for f in todo}
        for i, fu in enumerate(as_completed(futs), 1):
            f = futs[fu]
            try:
                r = fu.result()
            except Exception as e:
                r = {"error": str(e)[-500:]}
            append("base-runs", {"file": f, "target": tgt, **r})
            if i % 50 == 0 or i == len(todo):
                print(f"  {i}/{len(todo)}", flush=True)


def oracle_of(c, base_runs):
    """Every case of the fix's test files (as they are in the target) that
    passes on the base, per file. Files whose base run did not complete are
    left out."""
    o = {}
    for f in c["test_files"]:
        br = base_runs.get(f)
        if br and br.get("complete") and br.get("ok"):
            o[f] = br["ok"]
    return o


def added_by_fix(c, failing):
    """The failing cases the fix itself added. Output names carry the file's
    testprefix ("intpkey-1.0" for do_test 1.0), so match on the suffix."""
    out = {}
    for f, names in failing.items():
        added = c["added_tests"].get(f, [])
        hit = [n for n in names if any(n == a or n.endswith("-" + a) for a in added)]
        if hit:
            out[f] = hit
    return out


# --------------------------------------------------------------- verbatim

def reverse_impl_diff(c):
    return git("diff", "--binary", c["id"], f"{c['id']}^1", "--", *c["impl_files"]).stdout


def apply_patch(tree, text):
    """Exact (git apply), else fuzzy (patch -F2). Returns (mode or None, log)."""
    r = run(["git", "apply", "--whitespace=nowarn", "-"], cwd=tree, input=text, check=False)
    if r.returncode == 0:
        return "exact", ""
    r = run(["patch", "-p1", "--batch", "--forward", "--no-backup-if-mismatch", "-F2", "--dry-run"],
            cwd=tree, input=text, check=False)
    if r.returncode == 0:
        run(["patch", "-p1", "--batch", "--forward", "--no-backup-if-mismatch", "-F2"], cwd=tree, input=text)
        return "fuzzy", r.stdout[-800:]
    return None, r.stdout[-1500:]


def tree_diff(base, tree, files):
    return "".join(run(["diff", "-u", "--label", f"a/{f}", "--label", f"b/{f}",
                        str(base / f), str(tree / f)], check=False).stdout for f in files)


def gate(cid, kind, text, oracle, jobs, files=None, slot=None, outdir=None):
    """Apply an injection to a copy of the base, build, run the oracle files.
    Returns the record (and writes outdir/injection.patch when confirmed).
    slot names the scratch directory, so concurrent runs on one candidate
    (different models) do not collide."""
    base_src, base_tf = base_paths()
    slot = slot or cid[:12]
    outdir = outdir or DATASET / "bugs" / cid[:12]
    tree = WORK / "inj" / slot / "src"
    rec = {"kind": kind}
    try:
        if tree.exists():
            shutil.rmtree(tree)
        shutil.copytree(base_src, tree, symlinks=True)
        mode, log = apply_patch(tree, text)
        rec["apply"] = mode or "fails"
        if not mode:
            rec["apply_log"] = log
            return rec
        changed = files or sorted({m.group(1) for m in re.finditer(r"^\+\+\+ b/(\S+)", text, re.M)})
        inj = tree_diff(base_src, tree, changed)
        if not inj.strip():
            rec["apply"] = "noop"
            return rec
        tf, secs, blog = build_testfixture(tree, tree.parent / "build", jobs=jobs)
        rec["build_seconds"] = round(secs)
        if not tf:
            rec["build"] = "failed"
            rec["build_log"] = blog[-2000:]
            return rec
        rec["build"] = "ok"
        runs, failing = {}, {}
        for f, names in oracle.items():
            r = run_testfile(tf, tree, f)
            runs[f] = {k: r[k] for k in ("complete", "rc", "timeout", "seconds", "failed", "tail")}
            passing = set(r["ok"])
            bad = [n for n in names if n not in passing]
            if bad:
                failing[f] = bad
        rec["runs"] = runs
        rec["oracle_failing"] = failing
        restore = WORK / "inj" / slot / "restore"
        if restore.exists():
            shutil.rmtree(restore)
        shutil.copytree(tree, restore, symlinks=True, ignore=shutil.ignore_patterns("build"))
        rr = run(["patch", "-p1", "-R", "--batch", "--no-backup-if-mismatch"], cwd=restore, input=inj, check=False)
        rec["restored_identical"] = rr.returncode == 0 and all(
            filecmp.cmp(base_src / f, restore / f, shallow=False) for f in changed)
        if failing and rec["restored_identical"]:
            outdir.mkdir(parents=True, exist_ok=True)
            (outdir / "injection.patch").write_text(inj)
            rec["injection_sha256"] = hashlib.sha256(inj.encode()).hexdigest()
        return rec
    finally:
        shutil.rmtree(WORK / "inj" / slot, ignore_errors=True)


def cmd_verbatim(a):
    tgt = target_commit()
    cands = candidates()
    base_runs = latest("base-runs", key="file")
    done = latest("verbatim")
    ids = [i for i in a.ids.split(",") if i] if a.ids else sorted(cands, key=lambda i: cands[i]["date"], reverse=True)
    ids = [i for i in ids if i in cands]
    todo = []
    for i in ids:
        if not a.ids and i in done and done[i].get("target") == tgt and done[i].get("result") != "error":
            continue
        todo.append(i)
    if a.limit:
        todo = todo[:a.limit]
    print(f"{len(todo)} candidates to try", flush=True)

    def one(cid):
        c = cands[cid]
        o = oracle_of(c, base_runs)
        rec = {"id": cid, "target": tgt, "date": c["date"], "subject": c["subject"],
               "oracle_files": {f: len(n) for f, n in o.items()}}
        if not o:
            rec["result"] = "no_oracle"
            return rec
        g = gate(cid, "verbatim", reverse_impl_diff(c), o, a.jobs_per)
        rec["attempt"] = g
        rec["fix_added_failing"] = added_by_fix(c, g.get("oracle_failing") or {})
        rec["result"] = ("confirmed" if g.get("injection_sha256") else
                         "apply_fails" if g.get("apply") in ("fails", "noop") else
                         "build_fails" if g.get("build") == "failed" else
                         "not_restorable" if g.get("oracle_failing") else "oracle_passes")
        return rec

    counts = {}
    with ThreadPoolExecutor(a.j) as ex:
        futs = {ex.submit(one, cid): cid for cid in todo}
        for i, fu in enumerate(as_completed(futs), 1):
            cid = futs[fu]
            try:
                rec = fu.result()
            except Exception as e:
                rec = {"id": cid, "target": tgt, "result": "error", "error": str(e)[-1500:]}
            append("verbatim", rec)
            counts[rec["result"]] = counts.get(rec["result"], 0) + 1
            if i % 10 == 0 or i == len(todo):
                print(f"  {i}/{len(todo)} {counts}", flush=True)


# ----------------------------------------------------------------- report

def cmd_report(a):
    cands = candidates()
    v = latest("verbatim")
    counts = {}
    for r in v.values():
        counts[r["result"]] = counts.get(r["result"], 0) + 1
    print(f"candidates {len(cands)}; verbatim tried {len(v)}: {counts}")


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("mine")
    p = sub.add_parser("base")
    p.add_argument("-j", type=int, default=16)
    p = sub.add_parser("verbatim")
    p.add_argument("-j", type=int, default=8)
    p.add_argument("--jobs-per", type=int, default=2)
    p.add_argument("--limit", type=int, default=0)
    p.add_argument("--ids", default="")
    sub.add_parser("report")
    a = ap.parse_args()
    WORK.mkdir(parents=True, exist_ok=True)
    {"mine": cmd_mine, "base": cmd_base, "verbatim": cmd_verbatim, "report": cmd_report}[a.cmd](a)


# A target other than SQLite replaces the target-specific names above.
if os.environ.get("ETNA_KIND", "sqlite") != "sqlite":
    from importlib import import_module as _imp
    _t = _imp("target_" + os.environ["ETNA_KIND"])
    globals().update({k: v for k, v in vars(_t).items() if not k.startswith("_") and k not in
                      ("os", "re", "time", "shutil", "subprocess", "fcntl", "Path")})


if __name__ == "__main__":
    main()
