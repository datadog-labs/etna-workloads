#!/usr/bin/env python3
"""Run DuckDB test units with the unittest binary of a built tree and report per-case outcomes.

A unit is either a sqllogictest file path (test/...test[_slow]) or "cpp:<file>::<TEST_CASE name>".
Each unit runs in its own process (guard.py: own session, timeout, RSS cap) with a private
--temp-dir-root, a Catch XML report written to an absolute path, and --emit-test-events.

Outcome per case:
  pass        Catch OverallResult success=true and (for slt) event status ok
  fail        Catch success=false, or event status error
  skip        slt end event status skip-requirement (not usable as oracle)
  crash       process died without a complete report (signal, ASan/UBSan abort)  -> counts as failing
  timeout     killed by the wall-clock limit                                       -> counts as failing
  rss         killed by the memory cap                                              -> counts as failing
  nomatch     the binary ran but reported no such case (test name not registered)
  infra       could not run (spawn failure, disk full, missing binary)             -> retry, never a result
usage: runtests.py TREE OUT.json UNIT... [--jobs N] [--timeout S] [--rss-mb MB] [--units-file F]
"""
import argparse, json, os, re, shutil, subprocess, sys, tempfile, time
import xml.etree.ElementTree as ET
from concurrent.futures import ThreadPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
FAILING = {"fail", "crash", "timeout", "rss"}
EVENT_RE = re.compile(r"\[TEST_EVENT\] (\{.*\})")
INFRA_RE = re.compile(r"No space left on device|ENOSPC|Disk quota exceeded", re.I)


def clean_env(home):
    """A minimal, deterministic environment: no CI/agent variables (DuckDB's shell changes its output
    when AI_AGENT is set), fixed locale and time zone, private HOME."""
    os.makedirs(home, exist_ok=True)
    return {"PATH": "/usr/local/bin:/usr/bin:/bin", "HOME": home, "LANG": "C.UTF-8", "LC_ALL": "C.UTF-8",
            "TZ": "UTC", "ASAN_OPTIONS": "detect_leaks=0:abort_on_error=1:disable_coredump=1",
            "UBSAN_OPTIONS": "print_stacktrace=1:halt_on_error=1"}


def runner_flags(tree, d):
    """Temp-dir and event flags that this tree's unittest understands (older revisions differ).
    Returns (flags, parallel_safe)."""
    def src(rel):
        try:
            return open(os.path.join(tree, rel), errors="replace").read()
        except OSError:
            return ""
    main, cfg = src("test/unittest.cpp"), src("test/helpers/test_config.cpp")
    flags, safe = [], True
    if "temp_dir_root" in cfg:
        flags += ["--temp-dir-root", os.path.join(d, "tmp"), "--temp-dir-destroy", "always"]
    elif '"--test-temp-dir"' in main:
        flags += ["--test-temp-dir", os.path.join(d, "tmp")]
    else:
        safe = False
    if '"--emit-test-events"' in main:
        flags.append("--emit-test-events")
    return flags, safe


def catch_spec(name):
    # Catch v2 test spec: escape characters that have meaning in filters.
    return re.sub(r"([\\,\[\]\"*~^])", r"\\\1", name)


def parse_report(xml_text, stderr_text):
    """Return {case_name: (outcome, detail)} from a Catch XML report (possibly truncated)."""
    out = {}
    try:
        root = ET.fromstring(xml_text)
    except ET.ParseError:
        return None
    for tc in root.iter("TestCase"):
        name = tc.get("name")
        res = tc.find("OverallResult")
        if res is None:
            continue
        ok = res.get("success") == "true"
        events = [json.loads(m.group(1)) for m in EVENT_RE.finditer(ET.tostring(tc, encoding="unicode"))]
        ends = [e for e in events if e.get("event") == "end"]
        status = ends[-1]["status"] if ends else None
        detail = ""
        if status == "skip-requirement":
            out[name] = ("skip", ends[-1].get("data", "")[:300])
            continue
        if not ok or status == "error":
            locs = [f"{e.get('filename')}:{e.get('line')}" for e in tc.iter() if e.tag in ("Failure", "Expression", "Exception", "FatalErrorCondition") and e.get("line")]
            msgs = [" ".join(t.strip() for t in e.itertext() if t.strip()) for e in tc.iter()
                    if e.tag in ("Expression", "Exception", "FatalErrorCondition")]
            err = "".join((e.text or "") for e in tc.iter() if e.tag == "StdErr")
            err = "\n".join(l for l in err.splitlines() if not l.startswith("[TEST_EVENT]") and not set(l) <= set("= ")).strip()
            detail = ("; ".join(locs) + " :: " + " | ".join(m for m in msgs if m) + " " + err)[:1200]
            out[name] = ("fail", detail)
        else:
            out[name] = ("pass", "")
    return out


def run_unit(tree, unit, timeout, rss_mb, scratch):
    binary = os.path.join(tree, "build/relassert/test/unittest")
    if not os.path.exists(binary):
        return {unit: ("infra", "missing binary")}
    if unit.startswith("cpp:"):
        fname, _, case = unit[4:].partition("::")
        spec, expect = catch_spec(case), case
    else:
        spec, expect = unit, unit
    d = tempfile.mkdtemp(prefix="run-", dir=scratch)
    try:
        xmlp = os.path.join(d, "report.xml")
        log = os.path.join(d, "log.txt")
        cmd = [sys.executable, os.path.join(HERE, "guard.py"), "--timeout", str(timeout), "--rss-mb", str(rss_mb),
               "--log", log, "--cwd", tree, "--",
               binary] + runner_flags(tree, d)[0] + ["-r", "xml", "-o", xmlp, spec]
        env = clean_env(os.path.join(d, "home"))
        p = subprocess.run(cmd, capture_output=True, text=True, env=env)
        g = [l for l in p.stderr.splitlines() if l.startswith("GUARD ")]
        guard = json.loads(g[-1][6:]) if g else {"status": "spawn-failed"}
        logtxt = open(log, errors="replace").read() if os.path.exists(log) else ""
        xml_text = open(xmlp, errors="replace").read() if os.path.exists(xmlp) else ""
        if INFRA_RE.search(logtxt):
            return {expect: ("infra", "disk full")}
        if guard["status"] == "spawn-failed":
            return {expect: ("infra", "spawn failed")}
        if guard["status"] in ("timeout", "rss-cap"):
            return {expect: ("timeout" if guard["status"] == "timeout" else "rss", f"killed after {guard['secs']}s")}
        cases = parse_report(xml_text, logtxt) if xml_text else None
        if cases is None or (expect not in cases and guard["rc"] != 0):
            tail = re.sub(r"\s+", " ", logtxt[-800:])
            return {expect: ("crash", f"rc={guard['rc']} {tail}")}
        if expect not in cases:
            return {expect: ("nomatch", f"rc={guard['rc']}")}
        res = {expect: cases[expect]}
        if guard["rc"] != 0 and res[expect][0] == "pass":
            # Catch says the case passed but the process failed afterwards (e.g. sanitizer at exit)
            res[expect] = ("crash", f"rc={guard['rc']} after pass")
        return res
    finally:
        shutil.rmtree(d, ignore_errors=True)


def run_units(tree, units, jobs=8, timeout=600, rss_mb=12000, scratch=None, retries=2):
    scratch = scratch or os.environ.get("ETNA_RUNTMP") or os.path.join(os.environ.get("ETNA_WORK", os.path.expanduser("~/duckdb-etna-work")), "runtmp")
    os.makedirs(scratch, exist_ok=True)
    results = {}
    todo = list(units)
    if not runner_flags(tree, scratch)[1]:
        jobs = 1  # this revision's runner shares one temp dir under the tree: run serially
    for attempt in range(retries + 1):
        with ThreadPoolExecutor(jobs) as ex:
            for u, r in zip(todo, ex.map(lambda u: run_unit(tree, u, timeout, rss_mb, scratch), todo)):
                results[u] = list(r.values())[0]
        todo = [u for u in todo if results[u][0] == "infra"]
        if not todo:
            break
        time.sleep(30)
    return results


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("tree"); ap.add_argument("out"); ap.add_argument("units", nargs="*")
    ap.add_argument("--units-file"); ap.add_argument("--jobs", type=int, default=8)
    ap.add_argument("--timeout", type=int, default=600); ap.add_argument("--rss-mb", type=int, default=12000)
    a = ap.parse_args()
    units = list(a.units) + ([l.strip() for l in open(a.units_file) if l.strip()] if a.units_file else [])
    res = run_units(a.tree, units, a.jobs, a.timeout, a.rss_mb)
    json.dump({u: {"outcome": o, "detail": d} for u, (o, d) in res.items()}, open(a.out, "w"), indent=1)
    from collections import Counter
    print(Counter(o for o, _ in res.values()))
