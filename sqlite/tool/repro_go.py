#!/usr/bin/env python3
"""Standalone reproducers for Go compiler bugs (ETNA_KIND=go).

A reproducer is repro.go, run in an empty directory as `go run -trimpath
repro.go`, or repro.sh, run as `GO=<go> bash repro.sh` (for errorcheck-style
bugs: build and print the diagnostics), with the clean go1.27.3 toolchain and
with the injected one. Outputs are compared after replacing toolchain, work
and temporary paths with placeholders, since the two toolchains live at
different paths.
The harness requires the same output (stdout+stderr, exit status) on two
clean runs and a different one on the buggy build.

Usage:
  repro_go.py run [-j N] [--ids a,b] [--limit K] [--model M] [--budget USD]
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
import re  # noqa: E402
import target_go as _tgo  # noqa: E402

AGENT_TIMEOUT = int(os.environ.get("ETNA_AGENT_TIMEOUT", "2400"))
RUN_TIMEOUT = int(os.environ.get("ETNA_REPRO_TIMEOUT", "120"))  # go run compiles first
STAGE = "repro"

TASK = """\
# Task: write a standalone reproducer for a Go compiler bug

`injection.patch` re-introduces a historical bug into the Go compiler of
{target}; `fix.patch` is the upstream commit that originally fixed it
({date}). With the bug present, these upstream tests fail:

{failing}

Tests named Test/<path> are programs in `tree/test/<path>` run by the
test/ harness (their first line says how: // run, // compile,
// errorcheck, // rundir, ...); other names are Go tests in the compiler's
packages. `tree/` is the clean {target} source, for reading only.

Two toolchains are provided:

  bin/go-clean   Go {target}
  bin/go-buggy   Go {target} with injection.patch applied to the compiler

Write a reproducer whose output (stdout and stderr together, plus the exit
status) differs between the two toolchains: wrong program output, a compiler
crash (internal compiler error), a missing or wrong compile error, or a
program that crashes. Prefer:

1. `repro.go`: a single-file program, run as `go run -trimpath repro.go` in
   an empty directory. For a // run test, the test program itself is often
   the right reproducer (drop test-harness-only comments if needed).
2. `repro.sh`: a bash script run in an empty directory as
   `GO=<toolchain's go> bash repro.sh`, using only "$GO" (e.g. to
   `"$GO" build -gcflags=... ./x.go` and print the compiler's diagnostics,
   or to build a package from several files the script writes).

Use relative file names and `-trimpath` so paths do not leak into output;
the harness also replaces toolchain and temporary paths with placeholders.
Output must be deterministic on the clean toolchain (no timing, maps
iterated in random order, goroutine scheduling races, addresses).

Run `./check.sh` to compare the two toolchains on your reproducer.

If the failure only exists inside the test harness (asmcheck/codegen
assembly checks, compiler-internal unit tests with no user-visible effect),
do not fake it: write `NOREPRO.md` explaining why, and no reproducer.

When done, write `NOTES.md`: a few lines on what the reproducer does and
what differs between the toolchains.
"""

CHECK = """\
#!/bin/bash
cd "$(dirname "$0")"
exec python3 {tool}/repro_go.py _check "$PWD"
"""


def _normalize(out, go, cwd):
    goroot = str(Path(go).resolve().parent.parent)
    out = out.replace(goroot, "$GOROOT").replace(str(Path(go).parent.parent), "$GOROOT")
    out = out.replace(str(cwd), "$WORK")
    out = re.sub(r"/tmp/go-build\d+", "$TMP", out)
    out = re.sub(r"(/tmp|/var/folders/[^/]+/[^/]+/T)/[A-Za-z0-9_.-]*go-?build[^/\s]*", "$TMP", out)
    return out


def run_repro(go, workdir):
    wd = Path(workdir)
    if not ((wd / "repro.go").exists() or (wd / "repro.sh").exists()):
        return None, None
    cwd = Path(tempfile.mkdtemp(prefix="rp-", dir=E.WORK))
    try:
        for f in ("repro.go", "repro.sh"):
            if (wd / f).exists():
                shutil.copy(wd / f, cwd / f)
        env = {**_tgo._env(Path(go).resolve().parent.parent), "GO": str(go),
               "PATH": f"{Path(go).parent}:{os.environ.get('PATH', '')}"}
        cmd = ["bash", "repro.sh"] if (cwd / "repro.sh").exists() else [str(go), "run", "-trimpath", "repro.go"]
        p = subprocess.Popen(cmd, cwd=cwd, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                             start_new_session=True)
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
        return _normalize(out, go, cwd), status
    finally:
        shutil.rmtree(cwd, ignore_errors=True)


def agent_check(w):
    w = Path(w)
    for name in ("clean", "buggy"):
        out, rc = run_repro(w / "bin" / f"go-{name}", w)
        if out is None:
            print("no repro.go or repro.sh yet")
            return 1
        print(f"===== go-{name}: exit status {rc}\n{out[-2500:]}")
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
        base_src, base_py = E.base_paths()
        text = ppath.read_text()
        shutil.copytree(base_src, src, symlinks=True)
        E.run(["chmod", "-R", "u+w", str(src)])
        mode, log = E.apply_patch(src, text)
        if not mode:
            raise RuntimeError("injection does not apply: " + log[-500:])
        py, secs, blog = E.build_testfixture(src, bdir, jobs=2)
        if not py:
            raise RuntimeError("build failed: " + blog[-1500:])
        (w / "bin" / "go-clean").symlink_to(base_py)
        (w / "bin" / "go-buggy").symlink_to(py)
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
        for f in ("NOTES.md", "NOREPRO.md", "repro.go", "repro.sh"):
            if (w / f).exists():
                shutil.copy(w / f, d / f)
        rec["kind"] = "sh" if (w / "repro.sh").exists() else "go" if (w / "repro.go").exists() else None
        agent = rec.get("agent") or {}
        if not rec["kind"] and (agent.get("is_error") or "error" in agent):
            rec["result"] = "agent_error"
            return rec
        if not rec["kind"]:
            rec["result"] = "norepro" if (w / "NOREPRO.md").exists() else "no_output"
            return rec
        c1, s1 = run_repro(base_py, w)
        c2, s2 = run_repro(base_py, w)
        b1, t1 = run_repro(py, w)
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
    ids = [i for i in a.ids.split(",") if i] if a.ids else [i for i in bugs if i not in done]
    ids = [i for i in ids if i in bugs]
    if a.limit:
        ids = ids[:a.limit]
    print(f"{len(bugs)} strict bugs; {len(ids)} to do", flush=True)
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
