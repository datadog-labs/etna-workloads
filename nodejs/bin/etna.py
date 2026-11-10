#!/usr/bin/env python3
"""Node.js v26.13.0 bug workload: set up the release, apply/revert bugs, check them.

  etna.py setup <checkout-dir>             clone v26.13.0, configure --debug-node, build
  etna.py apply <checkout-dir> <bug-id>    apply the bug's injection.patch and rebuild
  etna.py revert <checkout-dir> <bug-id>   reverse it and rebuild
  etna.py check-repro <checkout-dir> <bug-id>   run the reproducer; BUG / CLEAN
  etna.py check-tests <checkout-dir> <bug-id>   run the bug's failing oracle cases; BUG / CLEAN
  etna.py list

Exit status of check-*: 1 if the bug is observed (BUG), 0 if clean (CLEAN), 2 on error.
Requires: git, python3, a C++20 toolchain (gcc >= 13.2 or clang >= 19.1), make.
"""
import json, os, re, shutil, subprocess, sys, tempfile

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BUGS = os.path.join(HERE, "bugs")
REPO = "https://github.com/nodejs/node.git"
TAG = "v26.13.0"
TAG_COMMIT = "18b32a3b1552e199a01f1a8d9fd64aa756d3b75b"
JOBS = str(os.cpu_count() or 4)


def sh(cmd, cwd=None, **kw):
    print("+", " ".join(cmd), file=sys.stderr)
    return subprocess.run(cmd, cwd=cwd, **kw)


def meta(bug):
    d = os.path.join(BUGS, bug)
    if not os.path.isdir(d):
        sys.exit(f"unknown bug id: {bug}")
    return d, json.load(open(os.path.join(d, "meta.json")))


def build(co, need_cc=False):
    ok = sh(["make", f"-j{JOBS}"], cwd=co).returncode == 0
    if ok and need_cc:
        ok = sh(["make", f"-j{JOBS}", "-C", "out", "BUILDTYPE=Release", "cctest"], cwd=co).returncode == 0
    return ok


def setup(co):
    if not os.path.exists(co):
        sh(["git", "clone", "--depth", "1", "--branch", TAG, REPO, co], check=True)
    head = subprocess.run(["git", "-C", co, "rev-parse", "HEAD"], capture_output=True, text=True).stdout.strip()
    if head != TAG_COMMIT:
        sys.exit(f"{co} is at {head}, expected {TAG} ({TAG_COMMIT})")
    sh(["./configure", "--debug-node"], cwd=co, check=True)
    if not build(co, need_cc=True):
        sys.exit("build failed")
    # test fixtures some oracle cases need (FFI fixture library, test addons)
    sh(["make", f"-j{JOBS}", "build-ffi-tests", "build-addons", "build-js-native-api-tests",
        "build-node-api-tests"], cwd=co, check=True)
    # Marauders: patches/ and marauder.toml at the checkout root
    shutil.copy(os.path.join(HERE, "marauder.toml"), os.path.join(co, "marauder.toml"))
    dst = os.path.join(co, "patches")
    if os.path.exists(dst):
        shutil.rmtree(dst)
    shutil.copytree(os.path.join(HERE, "patches"), dst)
    print("setup done")


def apply(co, bug, reverse=False):
    d, m = meta(bug)
    args = ["git", "apply"] + (["-R"] if reverse else []) + [os.path.join(d, "injection.patch")]
    if sh(args, cwd=co).returncode != 0:
        sys.exit(2)
    need_cc = any(c.startswith("cctest:") for c in m["failing_cases"])
    if not build(co, need_cc):
        sys.exit("build failed")


def normalise(text, node, rundir):
    text = text.replace(node, "<NODE>").replace(rundir, "<RUNDIR>")
    text = re.sub(r"/tmp/[^\s'\"):]*", "<TMP>", text)
    text = re.sub(r"\(node:\d+\)", "(node:<PID>)", text)
    return text


def run_repro(script, node):
    rundir = tempfile.mkdtemp(prefix="repro-")
    try:
        name = os.path.basename(script)
        shutil.copy(script, os.path.join(rundir, name))
        cmd = [node, name] if name.endswith(".js") else ["bash", name, node]
        env = {"PATH": "/usr/bin:/bin", "HOME": rundir, "TMPDIR": rundir, "LANG": "C.UTF-8"}
        try:
            p = subprocess.run(cmd, cwd=rundir, env=env, capture_output=True, timeout=60)
            out = (p.stdout + b"\n--stderr--\n" + p.stderr).decode(errors="replace")
            rc = p.returncode
        except subprocess.TimeoutExpired:
            out, rc = "<TIMEOUT>", "timeout"
        return normalise(out, node, rundir), rc
    finally:
        shutil.rmtree(rundir, ignore_errors=True)


def check_repro(co, bug):
    d, m = meta(bug)
    r = m.get("reproducer")
    if not r:
        print("no reproducer for this bug")
        sys.exit(2)
    exp = json.load(open(os.path.join(d, "repro.expected.json")))
    node = os.path.join(os.path.abspath(co), "out/Release/node")
    out, rc = run_repro(os.path.join(d, r["file"]), node)
    clean = (out == exp["output"] and rc == exp["exit"])
    print("CLEAN" if clean else "BUG")
    if not clean:
        print(f"expected exit {exp['exit']}, got {rc}", file=sys.stderr)
    sys.exit(0 if clean else 1)


def check_tests(co, bug):
    d, m = meta(bug)
    cases = m["failing_cases"]
    js = sorted({"/".join(c.split("/")[:2]) if c.startswith("wpt/") else c
                 for c in cases if not c.startswith("cctest:")})
    cc = [c[len("cctest:"):] for c in cases if c.startswith("cctest:")]
    failed = []
    if js:
        tmp = tempfile.mkdtemp(prefix="etna-tests-")
        p = subprocess.run(["python3", "tools/test.py", "-p", "tap", "-j", "4", "--shell",
                            "out/Release/node", "--temp-dir", tmp, *js], cwd=co,
                           capture_output=True, text=True, errors="replace")
        shutil.rmtree(tmp, ignore_errors=True)
        res = dict((n, v) for v, n in re.findall(r"^(not ok|ok) \d+ (\S+)", p.stdout, re.M))
        for c in cases:
            if c.startswith("cctest:"):
                continue
            if res.get(c) != "ok":
                failed.append(c)
    for name in cc:
        p = subprocess.run([os.path.join(co, "out/Release/cctest"), f"--gtest_filter={name}"],
                           cwd=co, capture_output=True, text=True, errors="replace")
        if not re.search(r"^\[\s+OK \] " + re.escape(name), p.stdout, re.M):
            failed.append("cctest:" + name)
    print("BUG" if failed else "CLEAN")
    for f in failed:
        print("  failing:", f, file=sys.stderr)
    sys.exit(1 if failed else 0)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    cmd = sys.argv[1]
    if cmd == "list":
        for b in sorted(os.listdir(BUGS)):
            m = json.load(open(os.path.join(BUGS, b, "meta.json")))
            print(f"{b}\t{m['tier']}\t{'strict' if m['strict'] else 'loose'}\t{m['fix']['subject']}")
    elif cmd == "setup":
        setup(sys.argv[2])
    elif cmd == "apply":
        apply(sys.argv[2], sys.argv[3])
    elif cmd == "revert":
        apply(sys.argv[2], sys.argv[3], reverse=True)
    elif cmd == "check-repro":
        check_repro(sys.argv[2], sys.argv[3])
    elif cmd == "check-tests":
        check_tests(sys.argv[2], sys.argv[3])
    else:
        sys.exit(__doc__)


if __name__ == "__main__":
    main()
