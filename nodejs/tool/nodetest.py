#!/usr/bin/env python3
"""Run Node.js tests and parse their results at the finest reported granularity.

JS tests go through the project's own runner (tools/test.py, TAP progress):
one case per test file, named like "parallel/test-foo".  C++ tests (test/cctest)
go through the gtest binary out/Release/cctest: one case per TEST, named
"cctest:Suite.Name".

Statuses: pass, fail, crash, timeout, skip, missing.
Only "pass" counts as passing; only fail/crash/timeout count as failing.
"""
import contextlib, fcntl, os, re, shutil, subprocess, tempfile
import memwatch

# Cases that bind fixed ports (sequential suite: common.PORT; cctest: e.g. 9444 in
# test_inspector_socket.cc) must not run concurrently with each other, even across
# slots.  They run serially under this host-wide lock.
SERIAL_LOCK = os.path.expanduser("~/node-etna-work/serial-tests.lock")
SERIAL_SUITES = {"sequential", "pseudo-tty"}


@contextlib.contextmanager
def serial_lock():
    with open(SERIAL_LOCK, "w") as f:
        fcntl.flock(f, fcntl.LOCK_EX)
        try:
            yield
        finally:
            fcntl.flock(f, fcntl.LOCK_UN)

# Suites run by tools/test.py whose cases are single test files.
JS_SUITES = {"parallel", "sequential", "es-module", "message", "pseudo-tty",
             "async-hooks", "module-hooks", "test-runner", "client-proxy",
             "report", "sea", "ffi", "wasi", "sqlite", "system-ca", "abort",
             "pummel", "internet", "known_issues", "wpt", "benchmark",
             "debugger", "inspector", "embedding", "tick-processor", "doctool",
             "code-cache", "fixtures-skip"}
# Suites we do not use as oracles:
#   known_issues: pass when the bug is present (inverted semantics)
#   internet: needs outbound network (unavailable in the sandbox)
#   pummel, benchmark: stress/perf, too slow and noisy
EXCLUDED_SUITES = {"known_issues", "internet", "pummel", "benchmark"}

TAP_LINE = re.compile(r"^(not ok|ok) \d+ (\S+)(.*)$")
GTEST_LINE = re.compile(r"^\[\s+(OK|FAILED|SKIPPED)\s+\] (\w+\.\w+)(?: \(\d+ ms\))?$")
GTEST_DEF = re.compile(r"^\s*TEST(?:_F|_P)?\(\s*(\w+)\s*,\s*(\w+)\s*\)", re.M)
ANSI = re.compile(r"\x1b\[[0-9;]*[A-Za-z]")


ADDON_SUITES = {"addons", "js-native-api", "node-api"}


def js_unit(path):
    """test/<suite>/<file>.(js|mjs|cjs) -> 'suite/name' or None.
    Addon suites nest one level: test/node-api/<dir>/test*.js -> 'node-api/<dir>/test*'."""
    m = re.match(r"^test/(addons|js-native-api|node-api)/([^/]+)/(test[^/]*)\.(js|mjs)$", path)
    if m:
        return f"{m.group(1)}/{m.group(2)}/{m.group(3)}"
    m = re.match(r"^test/([^/]+)/(test-[^/]+|[^/]+)\.(js|mjs|cjs)$", path)
    if not m or m.group(1) not in JS_SUITES or m.group(1) in EXCLUDED_SUITES:
        return None
    suite, name = m.group(1), m.group(2)
    if suite in ("parallel", "sequential", "pummel", "async-hooks", "es-module",
                 "module-hooks", "abort", "client-proxy", "sqlite", "wasi",
                 "ffi", "report", "sea", "system-ca", "test-runner", "debugger",
                 "inspector", "code-cache") and not name.startswith("test-"):
        return None  # helpers inside test dirs (e.g. test/es-module/helper.mjs)
    return f"{suite}/{name}"


def cctest_cases(tree, path):
    """test/cctest/<file>.cc -> ['cctest:Suite.Name', ...] defined in the release file."""
    if not re.match(r"^test/cctest/test_[^/]+\.cc$", path):
        return []
    f = os.path.join(tree, path)
    if not os.path.exists(f):
        return []
    src = open(f, errors="replace").read()
    return [f"cctest:{a}.{b}" for a, b in GTEST_DEF.findall(src)]


def units_for(tree, test_files):
    """Map a fix's test files to runnable units present in `tree`."""
    js, cc = [], []
    for t in test_files:
        u = js_unit(t)
        if u and os.path.exists(os.path.join(tree, t)):
            js.append(u)
        cc += cctest_cases(tree, t)
    return sorted(set(js)), sorted(set(cc))


def reap(tree):
    """Kill leftover processes running this tree's binaries (node, cctest).
    Timed-out tests can leave spawned children behind (e.g. tick-processor's --prof child
    loops forever); called after each run, when nothing else uses the tree's binaries."""
    prefix = os.path.join(os.path.realpath(tree), "out/Release/")
    killed = 0
    for pid in os.listdir("/proc"):
        if not pid.isdigit():
            continue
        try:
            exe = os.readlink(f"/proc/{pid}/exe")
        except OSError:
            continue
        if exe.startswith(prefix):
            try:
                os.kill(int(pid), 9)
                killed += 1
            except OSError:
                pass
    return killed


def parse_tap(text):
    """Parse tools/test.py TAP output into {case: status}."""
    res = {}
    lines = ANSI.sub("", text).splitlines()
    i = 0
    while i < len(lines):
        m = TAP_LINE.match(lines[i])
        i += 1
        if not m:
            continue
        verdict, name, rest = m.groups()
        if verdict == "ok":
            m = re.match(r"\s*# skip\s*(.*)$", rest, re.I)
            # Older tools/test.py (before ~2024) used a loose skip regex that also matches the
            # node:test summary line "# skipped <N>", reporting passing files as "# skip <N>".
            # A bare number as the "reason" is that counter, not a skip.
            status = "skip" if m and not re.fullmatch(r"\d+", m.group(1).strip()) else "pass"
        else:
            status = "fail"
        # The YAML diagnostic block follows (indented, so it never matches TAP_LINE):
        #   severity: crashed           -> crash (e.g. abort, exitcode -6)
        #   exitcode: -15 + stack "timeout" -> killed by the runner's timeout
        if verdict == "not ok":
            j = i
            block = []
            while j < len(lines) and not TAP_LINE.match(lines[j]) and lines[j] != "  ...":
                block.append(lines[j].strip())
                j += 1
            if "severity: crashed" in block:
                status = "crash"
            elif "exitcode: -15" in block and "timeout" in block:
                status = "timeout"
        res[name] = status
    return res


def parse_gtest(text):
    res = {}
    for line in ANSI.sub("", text).splitlines():
        m = GTEST_LINE.match(line.strip())
        if m:
            v, name = m.groups()
            res["cctest:" + name] = {"OK": "pass", "FAILED": "fail", "SKIPPED": "skip"}[v]
    return res


def run_js(tree, node, units, jobs=8, timeout=None, scratch=None, extra_env=None):
    """Run JS units -> {case: status}; units of SERIAL_SUITES run separately, serially, under the host lock."""
    par = [u for u in units if u.split("/")[0] not in SERIAL_SUITES]
    ser = [u for u in units if u.split("/")[0] in SERIAL_SUITES]
    res, out = _run_js(tree, node, par, jobs, timeout, scratch, extra_env)
    if ser:
        with serial_lock():
            r2, o2 = _run_js(tree, node, ser, 1, timeout, scratch, extra_env)
        res.update(r2)
        out += o2
    return res, out


def _run_js(tree, node, units, jobs=8, timeout=None, scratch=None, extra_env=None):
    """Run JS units with tools/test.py in `tree` using binary `node`.
    Each run gets a private temp dir (NODE_TEST_DIR) under `scratch`."""
    if not units:
        return {}, ""
    memwatch.require()  # RSS cap on every test process (see memwatch.py)
    tmp = tempfile.mkdtemp(prefix="nt-", dir=scratch)
    try:
        cmd = ["python3", "tools/test.py", "-p", "tap", "-j", str(jobs),
               "--shell", node, "--temp-dir", tmp, "--flaky-tests", "run"]
        if timeout:
            cmd += ["-t", str(timeout)]
        env = dict(os.environ, **(extra_env or {}))
        env.pop("NODE_OPTIONS", None)
        p = subprocess.run(cmd + units, cwd=tree, capture_output=True, text=True,
                           errors="replace", env=env)
        out = p.stdout + p.stderr
    finally:
        reap(tree)
        shutil.rmtree(tmp, ignore_errors=True)
    parsed = parse_tap(out)
    # A unit is one test file; most report one case named like the unit, but some
    # suites (wpt) report finer cases "unit/<subtest>".  Keep every case under a
    # requested unit; a unit with no case at all is "missing".
    res = {}
    for u in units:
        cases = {k: v for k, v in parsed.items() if k == u or k.startswith(u + "/")}
        res.update(cases or {u: "missing"})
    return res, out


def _run_one_gtest(exe, tree, case, timeout):
    name = case[len("cctest:"):]
    try:
        p = subprocess.run([exe, f"--gtest_filter={name}"], cwd=tree, capture_output=True,
                           text=True, errors="replace", timeout=timeout)
        out = p.stdout + p.stderr
        status = parse_gtest(out).get(case)
        if status is None:
            # No verdict line: the binary died inside the case, or the case does not exist.
            ran = re.search(r"^\[ RUN\s+\] " + re.escape(name) + "$", ANSI.sub("", out), re.M)
            status = "crash" if ran else "missing"
    except subprocess.TimeoutExpired as e:
        out = e.stdout.decode(errors="replace") if isinstance(e.stdout, bytes) else (e.stdout or "")
        status = "timeout"
    return status, out


def run_cctest(tree, cases, timeout=300, jobs=1):
    """Run each gtest case in its own process (out/Release/cctest, cwd = tree).
    One process per case: an abort in one case cannot take down the others, and the
    order-dependent interactions of a single long-running binary do not apply."""
    if not cases:
        return {}, ""
    memwatch.require()
    from concurrent.futures import ThreadPoolExecutor
    exe = os.path.join(tree, "out/Release/cctest")
    with serial_lock(), ThreadPoolExecutor(jobs) as ex:
        results = list(ex.map(lambda c: _run_one_gtest(exe, tree, c, timeout), cases))
    reap(tree)
    res = {c: s for c, (s, _) in zip(cases, results)}
    log = "\n".join(f"### {c}: {s}\n{o}" for c, (s, o) in zip(cases, results))
    return res, log
