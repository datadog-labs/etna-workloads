#!/usr/bin/env python3
"""Standalone reproducers for confirmed bugs.

For each strict bug (verbatim or adapted), a Claude agent turns the failing
upstream test cases into a standalone reproducer that needs only the sqlite3
CLI:

  repro.sql   run as  sqlite3 -batch -init /dev/null :memory: < repro.sql
  repro.sh    run as  SQLITE3=<cli> bash repro.sh   (in an empty directory)

The agent gets two CLIs built with testfixture's options (--debug and the
extensions): bin/sqlite3-clean (3.54.1) and bin/sqlite3-buggy (3.54.1 with
the injection). The harness then checks the reproducer itself:

  clean    output (stdout+stderr, exit status) is the same on two runs
  buggy    output differs from clean (wrong result, error, assert, crash)

and stores expected.txt (the clean output) beside it. A bug whose failure
needs the test harness itself (simulated OOM/IO errors, crash simulation)
gets NOREPRO.md instead and keeps its test-level oracle.

Usage:
  repro.py run [-j N] [--ids a,b] [--limit K] [--model M]
"""

import argparse
import json
import os
import shutil
import subprocess
import sys
import tempfile
import threading
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import sqlite_etna as E  # noqa: E402

AGENT_TIMEOUT = int(os.environ.get("ETNA_AGENT_TIMEOUT", "2400"))
RUN_TIMEOUT = int(os.environ.get("ETNA_REPRO_TIMEOUT", "10"))  # a hang shows as [timeout]
STAGE = "repro"

TASK = """\
# Task: write a standalone reproducer for a SQLite bug

`injection.patch` re-introduces a historical SQLite bug into SQLite
{target}; `fix.patch` is the upstream commit that originally fixed it
({date}). With the bug present, these upstream test cases fail:

{failing}

The test files are in `tree/test/` (they use SQLite's TCL harness; `tree/`
is the clean {target} source, for reading only).

Two command-line shells are provided, built with the test harness's options
(debug build: assert() is on; FTS3/4/5, R-Tree, Geopoly, session):

  bin/sqlite3-clean   SQLite {target}
  bin/sqlite3-buggy   SQLite {target} with injection.patch applied

Write a reproducer that needs only the shell, so that its output (stdout
and stderr together, plus the exit status) differs between the two shells:
a wrong result, a wrong error, an assertion failure, or a crash. Prefer, in
this order:

1. `repro.sql`: run as `sqlite3 -batch -init /dev/null :memory: < repro.sql`.
   Use this whenever the test's failure can be expressed in SQL. Use dot
   commands if needed (.testctrl, .dbconfig, .open, ...).
2. `repro.sh`: a bash script run in an empty directory as
   `SQLITE3=<path to shell> bash repro.sh` (only use "$SQLITE3", never a
   fixed path). Use this when you need a database file, several
   connections, CLI options, or to corrupt a file (printf/dd).

Make it as small as you can while keeping it reliable: translate only the
setup the failing case depends on. The harness sets things the shell does
not, for example a default page size of 1024 (`PRAGMA page_size=1024` before
creating tables) and SQLITE_DEFAULT_PAGE_SIZE-dependent layouts; carry over
whatever the test relies on. The output must be deterministic on the clean
shell (no timestamps, random(), file paths, or memory addresses).

Run `./check.sh` to compare the two shells on your reproducer.

If the failure only exists inside the test harness (simulated malloc or I/O
failures from faultsim/ioerr, crash simulation, test_* TCL commands with no
shell equivalent), do not fake it: write `NOREPRO.md` explaining what the
test needs, and no reproducer.

When done, write `NOTES.md`: a few lines on what the reproducer does and
what differs between the shells.
"""

CHECK = """\
#!/bin/bash
# Run repro.sql or repro.sh on both shells and show the outputs.
cd "$(dirname "$0")"
exec python3 {tool}/repro.py _check "$PWD"
"""


def bug_list():
    """Strict bugs: id -> (tier, injection path, failing cases)."""
    tri = E.latest("triage")
    out = {}
    for r in E.latest("verbatim").values():
        if r.get("result") != "confirmed" or not r.get("fix_added_failing"):
            continue
        t = tri.get(r["id"], {})
        if t.get("kind") != "bug" or t.get("confidence") == "low":
            continue
        p = E.DATASET / "bugs" / r["id"][:12] / "injection.patch"
        if p.exists():
            out[r["id"]] = ("verbatim", p, r["attempt"]["oracle_failing"], r["fix_added_failing"])
    for r in E.latest("adapt-sonnet").values():
        if r.get("result") != "adapted_confirmed" or not r.get("fix_added_failing"):
            continue
        p = E.DATASET / "adapted-sonnet" / r["id"][:12] / "injection.patch"
        if p.exists() and r["id"] not in out:
            out[r["id"]] = ("adapted", p, r["attempt"]["oracle_failing"], r["fix_added_failing"])
    return out


# ------------------------------------------------------------------ CLIs

_base_lock = threading.Lock()


def build_cli(src_tree, bdir, jobs=2):
    """sqlite3 CLI from a tree, with testfixture's configure options."""
    if bdir.exists():
        shutil.rmtree(bdir)
    shutil.copytree(src_tree, bdir, symlinks=True)
    env = {**os.environ, "CC": "ccache gcc", "CCACHE_BASEDIR": str(bdir),
           "CCACHE_DIR": str(E.WORK / "ccache")}
    r = E.run(E.CONFIGURE, cwd=bdir, check=False, env=env)
    if r.returncode == 0:
        r = E.run(["make", f"-j{jobs}", "sqlite3"], cwd=bdir, check=False, env=env)
    if r.returncode or not (bdir / "sqlite3").exists():
        raise RuntimeError("CLI build failed: " + (r.stdout + r.stderr)[-1500:])
    return bdir / "sqlite3"


def base_cli():
    cli = E.WORK / "base-cli" / "sqlite3"
    with _base_lock:
        if not cli.exists():
            built = build_cli(E.base_paths()[0], E.WORK / "base-cli-build", jobs=8)
            cli.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy(built, cli)
            shutil.rmtree(E.WORK / "base-cli-build", ignore_errors=True)
    return cli


def buggy_cli(cid, patch_text, dest):
    tree = E.WORK / "repro-build" / cid[:12] / "src"
    try:
        if tree.exists():
            shutil.rmtree(tree)
        shutil.copytree(E.base_paths()[0], tree, symlinks=True)
        mode, log = E.apply_patch(tree, patch_text)
        if not mode:
            raise RuntimeError("injection does not apply: " + log[-500:])
        built = build_cli(tree, tree.parent / "build")
        shutil.copy(built, dest)
    finally:
        shutil.rmtree(E.WORK / "repro-build" / cid[:12], ignore_errors=True)


def run_repro(cli, workdir):
    """Run the reproducer in a scratch dir; returns (output, status)."""
    wd = Path(workdir)
    cwd = Path(tempfile.mkdtemp(prefix="rp-", dir=E.WORK))
    try:
        if (wd / "repro.sql").exists():
            with open(wd / "repro.sql", "rb") as f:
                r = subprocess.run([str(cli), "-batch", "-init", "/dev/null", ":memory:"], stdin=f,
                                   cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                   timeout=RUN_TIMEOUT)
        elif (wd / "repro.sh").exists():
            r = subprocess.run(["bash", str(wd / "repro.sh")], cwd=cwd,
                               env={**os.environ, "SQLITE3": str(cli)},
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=RUN_TIMEOUT)
        else:
            return None, None
        return r.stdout.decode("utf-8", "replace"), r.returncode
    except subprocess.TimeoutExpired as e:
        return (e.stdout or b"").decode("utf-8", "replace") + "\n[timeout]", "timeout"
    finally:
        shutil.rmtree(cwd, ignore_errors=True)


def agent_check(w):
    w = Path(w)
    for name in ("clean", "buggy"):
        out, rc = run_repro(w / "bin" / f"sqlite3-{name}", w)
        if out is None:
            print("no repro.sql or repro.sh yet")
            return 1
        print(f"===== sqlite3-{name}: exit status {rc}\n{out[-2500:]}")
    return 0


# ---------------------------------------------------------------- pipeline

def failing_text(oracle_failing, fix_added):
    lines = []
    for f, names in oracle_failing.items():
        added = set(fix_added.get(f, []))
        shown = sorted(names, key=lambda n: n not in added)[:15]
        more = f" (+{len(names) - 15} more)" if len(names) > 15 else ""
        lines.append(f"- `{f}`: " + ", ".join(f"{n}{' (added by the fix)' if n in added else ''}"
                                              for n in shown) + more)
    return "\n".join(lines)


def repro_one(cid, bug, model):
    tier, ppath, failing, added = bug
    c = _cands[cid]
    rec = {"id": cid, "tier": tier, "date": c["date"], "subject": c["subject"], "model": model}
    w = E.WORK / "repro" / cid[:12]
    try:
        if w.exists():
            shutil.rmtree(w)
        (w / "bin").mkdir(parents=True)
        shutil.copytree(E.base_paths()[0], w / "tree", symlinks=True)
        text = ppath.read_text()
        (w / "injection.patch").write_text(text)
        (w / "fix.patch").write_text(E.git("show", "--format=fuller", cid).stdout)
        shutil.copy(base_cli(), w / "bin" / "sqlite3-clean")
        buggy_cli(cid, text, w / "bin" / "sqlite3-buggy")
        (w / "TASK.md").write_text(TASK.format(target=E.TARGET, date=c["date"][:10],
                                               failing=failing_text(failing, added)))
        (w / "check.sh").write_text(CHECK.format(tool=Path(__file__).resolve().parent))
        (w / "check.sh").chmod(0o755)
        settings = {
            "sandbox": {"enabled": True, "autoAllowBashIfSandboxed": True, "allowUnsandboxedCommands": False,
                        "filesystem": {"allowWrite": [str(w), str(E.WORK), "/tmp"],
                                       "denyRead": ["~/.ssh", "~/.aws", "~/.dd-auth", "~/.vault-token", "~/dd",
                                                    "~/.config", "~/.gitconfig", "~/.git-credentials"]},
                        "network": {"allowedDomains": [], "strictAllowlist": True}},
            "permissions": {"allow": ["Bash", "Read", "Edit", "Write", "Glob", "Grep"],
                            "deny": ["WebFetch", "WebSearch"]}}
        (w / "settings.json").write_text(json.dumps(settings))
        E.wait_for_auth()
        t0 = time.time()
        try:
            r = subprocess.run(
                [os.environ.get("CLAUDE_BIN", os.path.expanduser("~/.local/bin/claude")), "-p",
                 "Read TASK.md and do the task it describes.", "--model", model,
                 "--settings", str(w / "settings.json"), "--output-format", "json", "--max-turns", "150"],
                cwd=w, capture_output=True, text=True, timeout=AGENT_TIMEOUT)
            meta = json.loads(r.stdout)
            rec["agent"] = {k: meta.get(k) for k in ("total_cost_usd", "num_turns", "is_error", "subtype")}
        except (subprocess.TimeoutExpired, json.JSONDecodeError) as e:
            rec["agent"] = {"error": type(e).__name__}
        rec["agent_seconds"] = round(time.time() - t0)

        d = E.DATASET / "repro" / cid[:12]
        d.mkdir(parents=True, exist_ok=True)
        for f in ("NOTES.md", "NOREPRO.md", "repro.sql", "repro.sh"):
            if (w / f).exists():
                shutil.copy(w / f, d / f)
        kind = "sql" if (w / "repro.sql").exists() else "sh" if (w / "repro.sh").exists() else None
        rec["kind"] = kind
        if not kind:
            rec["result"] = "norepro" if (w / "NOREPRO.md").exists() else "no_output"
            return rec
        c1, s1 = run_repro(w / "bin" / "sqlite3-clean", w)
        c2, s2 = run_repro(w / "bin" / "sqlite3-clean", w)
        b1, t1 = run_repro(w / "bin" / "sqlite3-buggy", w)
        rec["clean_status"], rec["buggy_status"] = s1, t1
        if (c1, s1) != (c2, s2):
            rec["result"] = "nondeterministic"
        elif (c1, s1) == (b1, t1):
            rec["result"] = "no_difference"
        else:
            rec["result"] = "confirmed"
            (d / "expected.txt").write_text(c1)
            (d / "buggy-output.txt").write_text(b1)
            (d / "expected-status.txt").write_text(f"{s1}\n")
        return rec
    finally:
        shutil.rmtree(w, ignore_errors=True)


_cands = {}


def cmd_run(a):
    _cands.update(E.candidates())
    bugs = bug_list()
    done = E.latest(STAGE)
    ids = [i for i in a.ids.split(",") if i] if a.ids else [i for i in bugs if i not in done]
    ids = [i for i in ids if i in bugs]
    if a.limit:
        ids = ids[:a.limit]
    print(f"{len(bugs)} strict bugs; {len(ids)} to do", flush=True)
    base_cli()
    counts, cost = {}, 0.0
    with ThreadPoolExecutor(a.j) as ex:
        futs = {ex.submit(repro_one, i, bugs[i], a.model): i for i in ids}
        for n, fu in enumerate(as_completed(futs), 1):
            i = futs[fu]
            try:
                rec = fu.result()
            except Exception as e:
                rec = {"id": i, "result": "error", "error": str(e)[-1500:]}
            E.append(STAGE, rec)
            cost += (rec.get("agent") or {}).get("total_cost_usd") or 0
            counts[rec["result"]] = counts.get(rec["result"], 0) + 1
            print(f"  {n}/{len(ids)} {counts} ${cost:.2f}", flush=True)


def main():
    if len(sys.argv) == 3 and sys.argv[1] == "_check":
        sys.exit(agent_check(sys.argv[2]))
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("run")
    p.add_argument("-j", type=int, default=8)
    p.add_argument("--ids", default="")
    p.add_argument("--limit", type=int, default=0)
    p.add_argument("--model", default="claude-sonnet-5-5")
    a = ap.parse_args()
    cmd_run(a)


if __name__ == "__main__":
    main()
