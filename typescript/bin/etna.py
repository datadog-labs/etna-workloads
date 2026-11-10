#!/usr/bin/env python3
"""TypeScript compiler bug workload: set up the release, apply/unset a bug, check it.

  etna.py setup DIR                 clone TypeScript v6.0.3 into DIR, npm ci, build
  etna.py list                      list bug names
  etna.py set DIR BUG               apply bugs/BUG/injection.patch and rebuild
  etna.py unset DIR BUG             reverse it and rebuild
  etna.py check-repro DIR BUG       run the reproducer; prints BUG / CLEAN
  etna.py check-tests DIR BUG       run the bug's failing oracle cases; prints BUG / CLEAN

Exit status of check-*: 1 = bug present, 0 = clean, 2 = unknown/error.
"""
import json, os, re, shutil, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BUGS = os.path.join(HERE, "bugs")
REPO = "https://github.com/microsoft/TypeScript.git"
RELEASE = "v6.0.3"
BUILD_TARGETS = ["tests", "tsc", "services", "tsserver"]


def sh(cmd, cwd=None, **kw):
    print("+", " ".join(cmd), file=sys.stderr)
    return subprocess.run(cmd, cwd=cwd, check=True, **kw)


def build(d):
    sh(["node", "node_modules/hereby/bin/hereby.js", *BUILD_TARGETS], cwd=d)


def setup(d):
    sh(["git", "clone", "--quiet", "--depth", "1", "--branch", RELEASE, REPO, d])
    sh(["npm", "ci", "--no-audit", "--no-fund"], cwd=d)
    build(d)


def patch_of(bug):
    return os.path.join(BUGS, bug, "injection.patch")


def set_bug(d, bug, reverse=False):
    sh(["git", "apply", *(["-R"] if reverse else []), patch_of(bug)], cwd=d)
    build(d)


def check_repro(d, bug):
    rdir = os.path.join(BUGS, bug, "repro")
    if not os.path.exists(os.path.join(rdir, "repro.sh")):
        print("UNKNOWN (no reproducer for this bug)")
        return 2
    root = os.path.abspath(d)
    td = tempfile.mkdtemp(prefix="etna-repro-")
    try:
        cwd = os.path.join(td, "r")
        shutil.copytree(rdir, cwd, ignore=shutil.ignore_patterns("expected_*", "NOTES.md"))
        env = {"PATH": os.environ["PATH"], "HOME": td, "TMPDIR": td, "LANG": "C.UTF-8",
               "TSC": os.path.join(root, "built/local/tsc.js"),
               "TYPESCRIPT": os.path.join(root, "built/local/typescript.js"),
               "NODE_OPTIONS": "--max-old-space-size=2048"}
        p = subprocess.run(["bash", "repro.sh"], cwd=cwd, env=env, stdout=subprocess.PIPE,
                           stderr=subprocess.STDOUT, timeout=300)
        out = p.stdout.decode(errors="replace")
        for a, b in ((os.path.realpath(root), "<TS>"), (root, "<TS>"), (os.path.realpath(cwd), "<CWD>"),
                     (cwd, "<CWD>"), (td, "<TMP>")):
            out = out.replace(a, b)
        got = f"exit={p.returncode}\n{out}"
    finally:
        shutil.rmtree(td, ignore_errors=True)
    clean = open(os.path.join(rdir, "expected_clean.txt")).read()
    bugged = open(os.path.join(rdir, "expected_injected.txt")).read()
    # The clean output is deterministic (verified when the reproducer was accepted);
    # any other output means the bug is present. Injected output may vary (e.g. the
    # depth at which a stack overflow is reported), so an exact match is only informative.
    if got == clean:
        print("CLEAN")
        return 0
    print("BUG" + ("" if got == bugged else " (output differs from clean; not identical to expected_injected.txt)"))
    return 1


def check_tests(d, bug):
    meta = json.load(open(os.path.join(BUGS, bug, "meta.json")))
    oracle = json.load(open(os.path.join(BUGS, bug, "oracle.json")))
    cases = meta["failing_cases"]
    groups = {}
    for t in cases:
        o = oracle[t]
        groups.setdefault(o["runner"], set()).add(o["grep"])
    reporter = os.path.join(HERE, "bin", "jsonl-reporter.cjs")
    status = {}
    for runner, greps in sorted(groups.items()):
        cfg = {"runners": [runner] if runner != "unittest" else ["transpile", "unittest"],
               "light": False, "noColors": True, "timeout": 40000}
        if runner == "unittest":
            cfg["runUnitTests"] = True
        json.dump(cfg, open(os.path.join(d, "test.config"), "w"))
        with tempfile.NamedTemporaryFile(suffix=".jsonl", delete=False) as tf:
            rep = tf.name
        env = dict(os.environ, ETNA_REPORT=rep, NODE_ENV="development")
        subprocess.run(["node", "node_modules/mocha/bin/_mocha", "-R", reporter, "--no-colors", "-t", "40000",
                        "-g", "|".join(f"(?:{g})" for g in sorted(greps)), "built/local/run.js"],
                       cwd=d, env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=3600)
        for line in open(rep):
            e = json.loads(line)
            if e.get("ev") in ("pass", "fail"):
                status[e["title"]] = e["ev"]
        os.unlink(rep)
    os.unlink(os.path.join(d, "test.config"))
    failing = [t for t in cases if status.get(t) == "fail"]
    missing = [t for t in cases if t not in status]
    if failing:
        print(f"BUG ({len(failing)}/{len(cases)} oracle cases fail)")
        return 1
    if missing:
        print(f"UNKNOWN ({len(missing)} cases did not run)")
        return 2
    print(f"CLEAN (all {len(cases)} cases pass)")
    return 0


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    cmd, args = sys.argv[1], sys.argv[2:]
    if cmd == "setup":
        setup(args[0])
    elif cmd == "list":
        print("\n".join(sorted(os.listdir(BUGS))))
    elif cmd == "set":
        set_bug(args[0], args[1])
    elif cmd == "unset":
        set_bug(args[0], args[1], reverse=True)
    elif cmd == "check-repro":
        return check_repro(args[0], args[1])
    elif cmd == "check-tests":
        return check_tests(args[0], args[1])
    else:
        print(__doc__)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
