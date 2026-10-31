#!/usr/bin/env python3
"""Standalone reproducers for Valkey bugs (ETNA_KIND=valkey).

Like repro.py, but a reproducer is always repro.sh: it starts a server and
drives it with the CLI. It is run in an empty directory as

  VALKEY_SERVER=<server> VALKEY_CLI=<cli> PORT=<port> bash repro.sh

The agent gets bin/clean/ (9.0.7) and bin/buggy/ (with the injection). The
harness checks the same way: same output (and exit status) on two clean runs,
a different one on the buggy build. The script runs in its own process group,
which is killed afterwards, so no server outlives it.

Usage:
  repro_valkey.py run [-j N] [--ids a,b] [--limit K] [--model M]
"""

import argparse
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import sqlite_etna as E  # noqa: E402
import repro as R  # noqa: E402  (bug_list, failing_text)
from target_valkey import _PortSlot  # noqa: E402

AGENT_TIMEOUT = int(os.environ.get("ETNA_AGENT_TIMEOUT", "2400"))
RUN_TIMEOUT = int(os.environ.get("ETNA_REPRO_TIMEOUT", "30"))
STAGE = "repro"

TASK = """\
# Task: write a standalone reproducer for a Valkey bug

`injection.patch` re-introduces a historical bug into Valkey {target};
`fix.patch` is the upstream commit that originally fixed it ({date}). With
the bug present, these upstream test cases fail:

{failing}

The test files are in `tree/tests/` (Valkey's TCL test suite; `tree/` is the
clean {target} source, for reading only).

Two builds are provided:

  bin/clean/valkey-server, bin/clean/valkey-cli   Valkey {target}
  bin/buggy/valkey-server, bin/buggy/valkey-cli   with injection.patch

Write `repro.sh`, a bash script that is run in an empty directory as

  VALKEY_SERVER=<server> VALKEY_CLI=<cli> PORT=<free port> bash repro.sh

and whose output (stdout and stderr together, plus the exit status) differs
between the two builds: a wrong reply, a wrong error, an assertion failure
or crash, or wrong replication/persistence behaviour. Rules:

- Use only "$VALKEY_SERVER", "$VALKEY_CLI" and "$PORT" (and $PORT+1, $PORT+2
  for extra servers such as replicas); never fixed paths or ports.
- Start servers in the background with `&` (not --daemonize), e.g.
  `"$VALKEY_SERVER" --port "$PORT" --save "" --appendonly no --dir . --logfile s.log &`,
  wait until `"$VALKEY_CLI" -p "$PORT" ping` answers, and shut them down at
  the end (`shutdown nosave`).
- Output must be deterministic on the clean build: no timestamps, pids, run
  ids, memory addresses or timing-dependent values. Do not print server logs
  raw; if a crash or assertion matters, print a fixed line when the log
  contains it (e.g. `grep -q "ASSERTION FAILED" s.log && echo ASSERTION`), or
  rely on the CLI failing to connect.
- Translate only the setup the failing case depends on; keep it short. If
  the test uses DEBUG commands or special configs, carry them over
  (`--enable-debug-command yes` is often needed).

Run `./check.sh` to compare the two builds on your reproducer.

If the failure only exists inside the test framework (test-only modules,
fault injection, timing races that need the harness), do not fake it:
write `NOREPRO.md` explaining why, and no reproducer.

When done, write `NOTES.md`: a few lines on what the reproducer does and
what differs between the builds.
"""

CHECK = """\
#!/bin/bash
cd "$(dirname "$0")"
exec python3 {tool}/repro_valkey.py _check "$PWD"
"""


def build_bins(src_tree, dest, slot):
    """Build server and CLI from a tree into dest/ (valkey-server, valkey-cli)."""
    bdir = E.WORK / "repro-build" / slot
    try:
        server, secs, log = E.build_testfixture(src_tree, bdir, jobs=2)
        if not server:
            raise RuntimeError("build failed: " + log[-1500:])
        dest.mkdir(parents=True, exist_ok=True)
        for b in ("valkey-server", "valkey-cli"):
            shutil.copy(bdir / "src" / b, dest / b)
    finally:
        shutil.rmtree(bdir, ignore_errors=True)


def base_bins():
    d = E.WORK / "base-bins"
    if not (d / "valkey-cli").exists():
        build_bins(E.base_paths()[0], d, "base")
    return d


def run_repro(bindir, workdir):
    wd = Path(workdir)
    if not (wd / "repro.sh").exists():
        return None, None
    cwd = Path(tempfile.mkdtemp(prefix="rp-", dir=E.WORK))
    try:
        with _PortSlot() as ps:
            env = {**os.environ, "VALKEY_SERVER": str(Path(bindir) / "valkey-server"),
                   "VALKEY_CLI": str(Path(bindir) / "valkey-cli"), "PORT": str(ps.base + 1)}
            p = subprocess.Popen(["bash", str(wd / "repro.sh")], cwd=cwd, env=env, stdout=subprocess.PIPE,
                                 stderr=subprocess.STDOUT, start_new_session=True)
            try:
                raw, _ = p.communicate(timeout=RUN_TIMEOUT)
                out, status = raw.decode("utf-8", "replace"), p.returncode
            except subprocess.TimeoutExpired:
                os.killpg(p.pid, 9)
                raw, _ = p.communicate()
                out, status = raw.decode("utf-8", "replace") + "\n[timeout]", "timeout"
            try:
                os.killpg(p.pid, 9)          # any server the script left running
            except ProcessLookupError:
                pass
            return out, status
    finally:
        shutil.rmtree(cwd, ignore_errors=True)


def agent_check(w):
    w = Path(w)
    for name in ("clean", "buggy"):
        out, rc = run_repro(w / "bin" / name, w)
        if out is None:
            print("no repro.sh yet")
            return 1
        print(f"===== {name}: exit status {rc}\n{out[-2500:]}")
    return 0


def repro_one(cid, bug, model, cands):
    tier, ppath, failing, added = bug
    c = cands[cid]
    rec = {"id": cid, "tier": tier, "date": c["date"], "subject": c["subject"], "model": model}
    w = E.WORK / "repro" / cid[:12]
    try:
        if w.exists():
            shutil.rmtree(w)
        w.mkdir(parents=True)
        shutil.copytree(E.base_paths()[0], w / "tree", symlinks=True)
        text = ppath.read_text()
        (w / "injection.patch").write_text(text)
        (w / "fix.patch").write_text(E.git("show", "--format=fuller", cid).stdout)
        shutil.copytree(base_bins(), w / "bin" / "clean")
        inj = E.WORK / "repro-src" / cid[:12]
        try:
            if inj.exists():
                shutil.rmtree(inj)
            shutil.copytree(E.base_paths()[0], inj, symlinks=True)
            mode, log = E.apply_patch(inj, text)
            if not mode:
                raise RuntimeError("injection does not apply: " + log[-500:])
            build_bins(inj, w / "bin" / "buggy", cid[:12])
        finally:
            shutil.rmtree(inj, ignore_errors=True)
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
        for f in ("NOTES.md", "NOREPRO.md", "repro.sh"):
            if (w / f).exists():
                shutil.copy(w / f, d / f)
        rec["kind"] = "sh" if (w / "repro.sh").exists() else None
        agent = rec.get("agent") or {}
        if not rec["kind"] and (agent.get("is_error") or "error" in agent):
            rec["result"] = "agent_error"         # API trouble, not an answer: retried
            return rec
        if not rec["kind"]:
            rec["result"] = "norepro" if (w / "NOREPRO.md").exists() else "no_output"
            return rec
        c1, s1 = run_repro(w / "bin" / "clean", w)
        c2, s2 = run_repro(w / "bin" / "clean", w)
        b1, t1 = run_repro(w / "bin" / "buggy", w)
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


def cmd_run(a):
    cands = E.candidates()
    bugs = R.bug_list()
    done = {i for i, r in E.latest(STAGE).items()
            if r.get("result") not in ("agent_error", "error")
            and not (r.get("result") == "no_output" and (r.get("agent") or {}).get("is_error"))}
    ids = [i for i in a.ids.split(",") if i] if a.ids else [i for i in bugs if i not in done]
    ids = [i for i in ids if i in bugs]
    if a.limit:
        ids = ids[:a.limit]
    print(f"{len(bugs)} strict bugs; {len(ids)} to do", flush=True)
    base_bins()
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
    p.add_argument("-j", type=int, default=8)
    p.add_argument("--ids", default="")
    p.add_argument("--limit", type=int, default=0)
    p.add_argument("--model", default="claude-sonnet-5-5")
    p.add_argument("--budget", type=float, default=0)
    cmd_run(ap.parse_args())


if __name__ == "__main__":
    main()
