"""Work trees, builds and test runs for the TypeScript compiler.

A work tree is a real copy of the read-only base build except for large,
never-written inputs, which are symlinks into the base: node_modules, the LKG
compiler in lib/, test cases and reference baselines. Every tree has its own
tests/baselines/local, test.config and TMPDIR, so runs never share state.
"""
import json, os, re, shutil, subprocess, sys

sys.path.insert(0, os.path.dirname(__file__))
import proc

WORK = os.path.expanduser("~/ts-etna-work")
BASE = os.path.join(WORK, "base")
TOOLS = os.path.dirname(os.path.abspath(__file__))
REPORTER = os.path.join(TOOLS, "jsonl-reporter.cjs")
LINKED = ["node_modules", "lib", "tests/cases", "tests/baselines/reference", "tests/lib"]
NODE_HEAP_MB = 6144


def mk_tree(dst, base=BASE, linked=LINKED):
    """Copy base to dst, symlinking LINKED paths. Copies take fresh mtimes."""
    os.makedirs(dst)
    def walk(rel):
        src = os.path.join(base, rel) if rel else base
        for name in os.listdir(src):
            r = os.path.join(rel, name) if rel else name
            s, d = os.path.join(base, r), os.path.join(dst, r)
            if r in linked:
                os.symlink(s, d)
            elif any(l.startswith(r + "/") for l in linked):
                os.makedirs(d)
                walk(r)
            elif os.path.isdir(s) and not os.path.islink(s):
                subprocess.run(["cp", "-r", "--no-preserve=mode,timestamps", s, d], check=True)
            else:
                shutil.copy(s, d, follow_symlinks=False)
    walk("")
    for d in ["tests/baselines/local", ".tmp"]:
        os.makedirs(os.path.join(dst, d), exist_ok=True)
    subprocess.run(["chmod", "-R", "u+w", dst], check=True)


def rm_tree(path):
    if os.path.isdir(path):
        subprocess.run(["chmod", "-R", "u+w", path], capture_output=True)
        shutil.rmtree(path, ignore_errors=True)


def env_for(tree):
    e = dict(os.environ)
    e["TMPDIR"] = os.path.join(tree, ".tmp")
    e["NODE_OPTIONS"] = f"--max-old-space-size={NODE_HEAP_MB}"
    e["NODE_ENV"] = "development"
    e.pop("CI", None)
    return e


def build(tree, log, targets=("tests", "tsc", "services", "tsserver"), timeout=1200):
    """Rebuild after a source change. Returns (ok, reason)."""
    rc, reason = proc.run(["node", "node_modules/hereby/bin/hereby.js", *targets], tree, log,
                          timeout=timeout, rss_mb=12288, env=env_for(tree))
    return rc == 0 and reason is None, reason


# --- test units --------------------------------------------------------------

def _esc(s):
    return re.escape(s).replace("/", "/")


def unit_for_case(path):
    """Map a test case file (repo-relative) to (runner, grep regex) or None."""
    m = re.match(r"tests/cases/(compiler|conformance)/.*\.tsx?$", path)
    if m:
        kind = m.group(1)
        # Suite titles: "<kind> tests for <path>[ (<config>)]"
        return kind, rf"^{kind} tests {kind} tests for {_esc(path)}( \(.*\))? "
    if re.match(r"tests/cases/fourslash/server/[^/]+\.ts$", path):
        return "fourslash-server", rf"^fourslash-server tests {_esc(path)} "
    if re.match(r"tests/cases/fourslash/[^/]+\.ts$", path) and not path.endswith("/fourslash.ts"):
        return "fourslash", rf"^fourslash tests {_esc(path)} "
    if re.match(r"tests/cases/project/[^/]+\.json$", path):
        return "project", rf"^projects tests Compiling project for .*: testcase (?:.*/)?{_esc(os.path.basename(path))}( \(.*\))? "
    if re.match(r"tests/cases/transpile/[^/]+\.ts$", path):
        return "transpile", rf"^transpile tests .*{_esc(os.path.basename(path))}"
    return None


def run_units(tree, units, out_jsonl, log, timeout=1800):
    """Run units [(runner, regex)] grouped by runner. Returns per-group status."""
    groups = {}
    for runner, rx in units:
        groups.setdefault(runner, []).append(rx)
    status = {}
    for runner, rxs in sorted(groups.items()):
        cfg = {"runners": [runner] if runner != "unittest" else ["transpile", "unittest"],
               "light": False, "noColors": True, "timeout": 40000}
        if runner == "unittest":
            cfg["runUnitTests"] = True
        with open(os.path.join(tree, "test.config"), "w") as f:
            json.dump(cfg, f)
        grep = "|".join(f"(?:{r})" for r in rxs)
        env = env_for(tree)
        env["ETNA_REPORT"] = out_jsonl
        with open(out_jsonl, "a") as f:
            f.write(json.dumps({"ev": "group", "runner": runner, "grep": grep}) + "\n")
        rc, reason = proc.run(["node", "node_modules/mocha/bin/_mocha", "-R", REPORTER, "--no-colors",
                               "-t", "40000", "-g", grep, "built/local/run.js"],
                              tree, log, timeout=timeout, rss_mb=8192, env=env)
        status[runner] = {"rc": rc, "killed": reason}
        with open(out_jsonl, "a") as f:
            f.write(json.dumps({"ev": "exit", "runner": runner, "rc": rc, "killed": reason}) + "\n")
    return status


def parse(out_jsonl):
    """Return {title: 'pass'|'fail'|'pending'} plus meta. A hook failure marks its
    suite failed (key 'suite:<title>'); a test begun but never ended in a killed
    or crashed group counts as failed."""
    res, meta = {}, {"groups": [], "incomplete": []}
    begun, group = None, None
    for line in open(out_jsonl):
        e = json.loads(line)
        ev = e["ev"]
        if ev == "group":
            group, begun, ended = e["runner"], None, False
        elif ev == "begin":
            begun = e["title"]
        elif ev in ("pass", "pending"):
            res.setdefault(e["title"], ev)
            if ev == "pass" and res[e["title"]] == "pass":
                pass
            begun = None
        elif ev == "fail":
            if e.get("hook"):
                res["suite:" + e["suite"]] = "fail"
            else:
                res[e["title"]] = "fail"
            begun = None
        elif ev == "end":
            ended = True
        elif ev == "exit":
            meta["groups"].append(e)
            if not ended:
                meta["incomplete"].append(group)
                if begun:
                    res[begun] = "fail"
            begun = None
    return res, meta


def case_status(res, title):
    """Status of a case, honouring failed enclosing-suite hooks."""
    if title in res and res[title] == "fail":
        return "fail"
    for k, v in res.items():
        if v == "fail" and k.startswith("suite:") and title.startswith(k[6:] + " "):
            return "fail"
    return res.get(title, "missing")
