#!/usr/bin/env python3
"""Standalone reproducers for DataFusion bugs (ETNA_KIND=datafusion).

A reproducer is repro.sql, run in an empty directory as
`datafusion-cli -q --format table -f repro.sql` with the CLI built from
clean 55.2.0 and from the injected tree. datafusion-cli is built in the
same fixed-path slots as the sqllogictests binary (target_datafusion.py),
then copied out, so a slot is only held while building.
The harness requires the same output (stdout+stderr, exit status) on two
clean runs and a different one on the buggy build.

Usage:
  repro_datafusion.py run [-j N] [--ids a,b] [--limit K] [--model M] [--budget USD]
"""

import argparse
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

sys.path.insert(0, str(Path(__file__).resolve().parent))
import sqlite_etna as E  # noqa: E402
import repro as R  # noqa: E402  (bug_list, failing_text)
import target_datafusion as T  # noqa: E402

AGENT_TIMEOUT = int(os.environ.get("ETNA_AGENT_TIMEOUT", "2400"))
RUN_TIMEOUT = int(os.environ.get("ETNA_REPRO_TIMEOUT", "120"))
STAGE = "repro"

TASK = """\
# Task: write a standalone reproducer for a DataFusion bug

`injection.patch` re-introduces a historical bug into DataFusion {target};
`fix.patch` is the upstream commit that originally fixed it ({date}). With
the bug present, these upstream SQL logic tests fail (files under
`tree/datafusion/sqllogictest/test_files/`; `file:line` names the failing
record):

{failing}

`tree/` is the clean {target} source, for reading only.

Two builds of the DataFusion command-line client are provided:

  bin/df-clean   datafusion-cli {target}
  bin/df-buggy   datafusion-cli {target} with injection.patch applied

Write `repro.sql`: SQL statements whose output (stdout and stderr together,
plus the exit status) differs between the two, when run in an empty
directory as

  <df> -q --format table -f repro.sql

Wrong query results, a panic, a wrong or missing error, or a different
EXPLAIN plan (when the plan is the bug) all count. The failing .slt
records are usually the right starting point: copy their statements and
queries. The sqllogictest runner uses settings the CLI does not, so set
what the bug needs explicitly (e.g. `SET datafusion.execution.target_partitions = 4;`,
`SET datafusion.execution.batch_size = ...;`). Make data inline (VALUES,
CREATE TABLE ... AS, or COPY ... TO a relative file the script then reads);
use only relative paths.

Output must be deterministic on the clean build: add ORDER BY to queries
whose row order is not fixed, and avoid timings, random functions and
now().

Run `./check.sh` to compare the two builds on your reproducer.

If the bug cannot be observed through SQL (it only shows through Rust APIs
or test-only configuration), do not fake it: write `NOREPRO.md` explaining
why, and no repro.sql.

When done, write `NOTES.md`: a few lines on what the reproducer does and
what differs between the builds.
"""

CHECK = """\
#!/bin/bash
cd "$(dirname "$0")"
exec python3 {tool}/repro_datafusion.py _check "$PWD"
"""

_base_lock = threading.Lock()


def build_cli(tree, dest):
    """Build datafusion-cli from `tree` in a slot and copy it to `dest`.
    Returns (path or None, log)."""
    with T._Slot() as slot:
        err = T._sync_tree(slot, Path(tree).resolve())
        if err:
            return None, err
        r = E.run(["cargo", "build", "-p", "datafusion-cli", "--bin", "datafusion-cli"],
                  cwd=slot.dir / "src", check=False, env=T._env(slot.dir / "target"), timeout=7200)
        exe = slot.dir / "target" / "debug" / "datafusion-cli"
        if r.returncode or not exe.exists():
            return None, (r.stdout + r.stderr)[-3000:]
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(exe, dest)
    return dest, ""


def base_cli():
    """datafusion-cli of the clean release, built once."""
    dest = E.WORK / "base-build" / "datafusion-cli"
    with _base_lock:
        if not dest.exists():
            base_src, _ = E.base_paths()
            p, log = build_cli(base_src, dest)
            if not p:
                raise RuntimeError("clean datafusion-cli build failed: " + log[-1500:])
    return dest


def run_repro(cli, workdir):
    wd = Path(workdir)
    if not (wd / "repro.sql").exists():
        return None, None
    cwd = Path(tempfile.mkdtemp(prefix="rp-", dir=E.WORK))
    try:
        shutil.copy(wd / "repro.sql", cwd / "repro.sql")
        env = {"PATH": os.environ.get("PATH", ""), "HOME": str(cwd), "TZ": "UTC",
               "RUST_BACKTRACE": "0", "LANG": "C.UTF-8"}
        p = subprocess.Popen([str(cli), "-q", "--format", "table", "-f", "repro.sql"], cwd=cwd, env=env,
                             stdout=subprocess.PIPE, stderr=subprocess.STDOUT, start_new_session=True)
        try:
            raw, _ = p.communicate(timeout=RUN_TIMEOUT)
            out, status = raw.decode("utf-8", "replace"), p.returncode
        except subprocess.TimeoutExpired:
            os.killpg(p.pid, 9)
            raw, _ = p.communicate()
            out, status = raw.decode("utf-8", "replace") + "\n[timeout]", "timeout"
        try:
            os.killpg(p.pid, 9)
        except ProcessLookupError:
            pass
        out = out.replace(str(cwd), "$WORK")
        out = re.sub(r"/[^\s'\"]*/(slots/\d+/src|base-src)/", "$SRC/", out)
        return out, status
    finally:
        shutil.rmtree(cwd, ignore_errors=True)


def agent_check(w):
    w = Path(w)
    for name in ("clean", "buggy"):
        out, rc = run_repro(w / "bin" / f"df-{name}", w)
        if out is None:
            print("no repro.sql yet")
            return 1
        print(f"===== df-{name}: exit status {rc}\n{out[-2500:]}")
    return 0


def repro_one(cid, bug, model, cands):
    tier, ppath, failing, added = bug
    c = cands[cid]
    rec = {"id": cid, "tier": tier, "date": c["date"], "subject": c["subject"], "model": model}
    w = E.WORK / "repro" / cid[:12]
    src = E.WORK / "repro-src" / cid[:12]
    bdir = E.WORK / "repro-build" / cid[:12]
    try:
        for d in (w, src, bdir):
            if d.exists():
                shutil.rmtree(d)
        (w / "bin").mkdir(parents=True)
        clean = base_cli()
        base_src, _ = E.base_paths()
        text = ppath.read_text()
        shutil.copytree(base_src, src, symlinks=True)
        E.run(["chmod", "-R", "u+w", str(src)])
        mode, log = E.apply_patch(src, text)
        if not mode:
            raise RuntimeError("injection does not apply: " + log[-500:])
        buggy, blog = build_cli(src, bdir / "datafusion-cli")
        if not buggy:
            raise RuntimeError("build failed: " + blog[-1500:])
        shutil.rmtree(src, ignore_errors=True)
        (w / "bin" / "df-clean").symlink_to(clean)
        (w / "bin" / "df-buggy").symlink_to(buggy)
        (w / "tree").symlink_to(base_src)
        (w / "injection.patch").write_text(text)
        (w / "fix.patch").write_text(E.git("show", "--format=fuller", cid).stdout)
        (w / "TASK.md").write_text(TASK.format(target=E.TARGET, date=c["date"][:10],
                                               failing=R.failing_text(failing, added)))
        (w / "check.sh").write_text(CHECK.format(tool=Path(__file__).resolve().parent))
        (w / "check.sh").chmod(0o755)
        settings = {
            "sandbox": {"enabled": True, "autoAllowBashIfSandboxed": True, "allowUnsandboxedCommands": False,
                        "filesystem": {"allowWrite": [str(w), str(E.WORK), "/tmp"],
                                       "denyRead": ["~/.ssh", "~/.aws", "~/.dd-auth", "~/.vault-token", "~/dd",
                                                    "~/.config", "~/.gitconfig", "~/.git-credentials"]},
                        "network": {"allowedDomains": [], "strictAllowlist": True,
                                    "allowLocalBinding": True, "allowAllUnixSockets": True}},
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
        for f in ("NOTES.md", "NOREPRO.md", "repro.sql"):
            if (w / f).exists():
                shutil.copy(w / f, d / f)
        rec["kind"] = "sql" if (w / "repro.sql").exists() else None
        agent = rec.get("agent") or {}
        if not rec["kind"] and (agent.get("is_error") or "error" in agent):
            rec["result"] = "agent_error"
            return rec
        if not rec["kind"]:
            rec["result"] = "norepro" if (w / "NOREPRO.md").exists() else "no_output"
            return rec
        c1, s1 = run_repro(clean, w)
        c2, s2 = run_repro(clean, w)
        b1, t1 = run_repro(buggy, w)
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
        for d in (w, src, bdir):
            shutil.rmtree(d, ignore_errors=True)


def cmd_run(a):
    cands = E.candidates()
    bugs = R.bug_list()
    done = {i for i, r in E.latest(STAGE).items() if r.get("result") not in ("agent_error", "error")}
    ids = [i for i in a.ids.split(",") if i] if a.ids else sorted(
        (i for i in bugs if i not in done), key=lambda i: cands[i]["date"], reverse=True)
    ids = [i for i in ids if i in bugs]
    if a.limit:
        ids = ids[:a.limit]
    print(f"{len(bugs)} strict bugs; {len(ids)} to do", flush=True)
    base_cli()
    counts, cost = {}, 0.0
    with ThreadPoolExecutor(a.j) as ex:
        futs = {ex.submit(repro_one, i, bugs[i], a.model, cands): i for i in ids}
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
            if a.budget and cost >= a.budget:
                print(f"budget ${a.budget:.0f} reached; stopping", flush=True)
                for f in futs:
                    f.cancel()


def main():
    if len(sys.argv) == 3 and sys.argv[1] == "_check":
        sys.exit(agent_check(sys.argv[2]))
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("run")
    p.add_argument("-j", type=int, default=6)
    p.add_argument("--ids", default="")
    p.add_argument("--limit", type=int, default=0)
    p.add_argument("--model", default="claude-sonnet-5-5")
    p.add_argument("--budget", type=float, default=0)
    cmd_run(ap.parse_args())


if __name__ == "__main__":
    main()
