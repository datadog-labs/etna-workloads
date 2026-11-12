"""Reproducers: standalone SQL scripts run with the DuckDB shell, verified by the harness.

A reproducer is accepted when, run from the tree root with a clean environment,
  * its normalised output (stdout+stderr) and exit status are identical in two runs on the clean build;
  * the injected build gives a different output or exit status;
  * the difference is not a version/source identifier.
make_from_slt() derives a script mechanically from a failing sqllogictest file (records up to and
including the failing one); it returns None for files using constructs it does not translate.
"""
import hashlib, os, re, shutil, subprocess, tempfile
import common
import runtests

RUNTMP = None  # overridden by the agent-facing checker (its sandbox can only write its slot)


def _runtmp():
    d = RUNTMP or os.path.join(common.WORK, "runtmp")
    os.makedirs(d, exist_ok=True)
    return d

BUILTIN = {"parquet", "json", "icu", "core_functions", "tpch", "tpcds", "skip_reload", "no_extension_autoloading"}
FORBIDDEN = re.compile(r"\b(version|source_id|pragma_version|duckdb_extensions|platform|pragma\s+version|"
                       r"current_setting\s*\(\s*'?(threads|memory_limit))\b", re.I)


def parse_slt(text):
    """Yield (lineno, kind, header_tokens, sql) records; kind in statement/query/directive."""
    lines = text.split("\n")
    i = 0
    while i < len(lines):
        l = lines[i]
        s = l.strip()
        if not s or s.startswith("#"):
            i += 1; continue
        tok = s.split()
        start = i + 1
        if tok[0] in ("statement", "query"):
            j = i + 1; body = []
            while j < len(lines) and lines[j].strip() != "" and lines[j].strip() != "----":
                body.append(lines[j]); j += 1
            # skip expected output / error block until blank line
            if j < len(lines) and lines[j].strip() == "----":
                j += 1
                while j < len(lines) and lines[j].strip() != "":
                    j += 1
            yield start, tok[0], tok, "\n".join(body)
            i = j
        else:
            yield start, "directive", tok, ""
            i += 1


def sub(text, var, val):
    return text.replace("${" + var + "}", val).replace("{" + var + "}", val)


def expand_loops(records):
    """Expand loop/foreach blocks (substituting ${var}); records keep their original line numbers.
    Returns None for constructs not expanded (concurrent loops, special foreach groups like <integral>)."""
    out, stack = [], []
    def emit(rec):
        (stack[-1]["body"] if stack else out).append(rec)
    for rec in records:
        ln, kind, tok, sql = rec
        if kind == "directive" and tok[0] in ("concurrentloop", "concurrentforeach"):
            return None
        if kind == "directive" and tok[0] == "loop":
            if len(tok) != 4:
                return None
            stack.append({"var": tok[1], "vals": [str(i) for i in range(int(tok[2]), int(tok[3]))], "body": []})
        elif kind == "directive" and tok[0] == "foreach":
            vals = tok[2:]
            if any(v.startswith("<") for v in vals):
                return None
            stack.append({"var": tok[1], "vals": vals, "body": []})
        elif kind == "directive" and tok[0] == "endloop":
            if not stack:
                return None
            blk = stack.pop()
            for v in blk["vals"]:
                for (l2, k2, t2, s2) in blk["body"]:
                    emit((l2, k2, [sub(x, blk["var"], v) for x in t2], sub(s2, blk["var"], v)))
        else:
            emit(rec)
    return None if stack else out


def make_from_slt(path, fail_line, threads1=False):
    text = open(path, errors="replace").read()
    out = ["SET threads=1;"] if threads1 else []
    skipping = False
    skip_next = False
    recs = expand_loops(list(parse_slt(text)))
    if recs is None:
        return None, "unsupported loop"
    # cut after the last expanded record at or before the failing line (a failure inside a loop may
    # come from any iteration; earlier iterations' later records are kept, which is harmless)
    last = max((i for i, r in enumerate(recs) if r[0] <= fail_line), default=-1)
    for ln, kind, tok, sql in recs[:last + 1]:
        if kind == "directive":
            d = tok[0]
            if d == "mode" and len(tok) > 1:
                skipping = tok[1] == "skip" if tok[1] in ("skip", "unskip") else skipping
                if tok[1] not in ("skip", "unskip", "output_result", "output_hash", "debug"):
                    return None, f"mode {tok[1]}"
                continue
            if skipping:
                continue
            if d == "require":
                if len(tok) > 1 and tok[1] in BUILTIN:
                    continue
                return None, "require " + " ".join(tok[1:])
            if d == "skipif":
                skip_next = len(tok) > 1 and tok[1] == "duckdb"; continue
            if d == "onlyif":
                skip_next = len(tok) > 1 and tok[1] != "duckdb"; continue
            if d in ("tags", "hash-threshold"):
                continue
            return None, "directive " + d
        if skipping:
            continue
        if skip_next:
            skip_next = False; continue
        if len(tok) > 2 and kind == "statement" and tok[2].startswith("con"):
            return None, "multiple connections"
        if kind == "query" and len(tok) > 3 and tok[3].startswith("con"):
            return None, "multiple connections"
        if re.search(r"__TEST_DIR__|\$\{|\{DATA_DIR\}|\{TEMP_DIR\}|\{[A-Z_]+\}|__WORKING_DIRECTORY__|__BUILD_DIRECTORY__", sql):
            return None, "test-runner substitution"
        sql = sql.rstrip()
        if not sql.endswith(";"):
            sql += ";"
        out.append(sql)
    if not out:
        return None, "no statements"
    return ".mode list\n.nullvalue NULL\n" + "\n".join(out) + "\n", "ok"


def private_root(tree, d):
    """A writable working directory whose top-level entries link to the tree (data/, test/, ...):
    relative reads resolve as from the tree root, while files DuckDB creates in the working
    directory (e.g. the default temp directory .tmp) go to scratch, never into the (read-only) tree."""
    root = os.path.join(d, "root")
    os.makedirs(root, exist_ok=True)
    for name in os.listdir(tree):
        if name in ("build", ".tmp", "duckdb_unittest_tempdir"):
            continue
        os.symlink(os.path.join(tree, name), os.path.join(root, name))
    return root


def normalise(out, tree, d, root):
    for a, b in ((root, "<ROOT>"), (os.path.realpath(tree), "<ROOT>"), (tree, "<ROOT>"), (d, "<TMP>")):
        out = out.replace(a, b)
    out = re.sub(r"0x[0-9a-f]{6,}", "0xADDR", out)
    return re.sub(r"==\d+==", "==PID==", out)


def run_script(tree, sql_path, timeout=120):
    """Run the shell on a script from a private root linked to the tree; return (status, normalised output)."""
    d = tempfile.mkdtemp(prefix="repro-", dir=_runtmp())
    try:
        root = private_root(tree, d)
        shell = os.path.join(tree, "build/relassert/duckdb")
        log = os.path.join(d, "out.txt")
        r = subprocess.run(["python3", os.path.join(common.TOOL, "guard.py"), "--timeout", str(timeout),
                            "--rss-mb", "12000", "--log", log, "--cwd", root, "--",
                            shell, "-batch", "-init", "/dev/null", "-f", sql_path, ":memory:"],
                           capture_output=True, text=True, env=runtests.clean_env(os.path.join(d, "home")))
        g = [l for l in r.stderr.splitlines() if l.startswith("GUARD ")]
        import json
        guard = json.loads(g[-1][6:]) if g else {"status": "spawn-failed", "rc": -1}
        out = open(log, errors="replace").read() if os.path.exists(log) else ""
        status = guard["status"] if guard["status"] != "exit" else str(guard["rc"])
        return status, normalise(out, tree, d, root)
    finally:
        shutil.rmtree(d, ignore_errors=True)


ABSPATH = re.compile(r"(^|[\s'\"(=])(/(home|tmp|root|usr|var|opt|mnt|proc|dev)\b|file:///)", re.M)


def verify(sql_text, clean_tree, injected_tree):
    if FORBIDDEN.search(sql_text):
        return {"ok": False, "why": "script mentions a version/platform identifier"}
    if ABSPATH.search(sql_text) or common.WORK in sql_text or common.HOME in sql_text:
        return {"ok": False, "why": "script uses an absolute path (not standalone)"}
    d = tempfile.mkdtemp(prefix="reprov-", dir=_runtmp())
    try:
        p = os.path.join(d, "repro.sql"); open(p, "w").write(sql_text)
        c1 = run_script(clean_tree, p); c2 = run_script(clean_tree, p)
        if c1 != c2:
            return {"ok": False, "why": "clean output not deterministic"}
        i1 = run_script(injected_tree, p)
        if i1 == c1:
            return {"ok": False, "why": "no difference between clean and injected"}
        i2 = run_script(injected_tree, p)
        if i2 != i1:
            return {"ok": False, "why": "injected output not deterministic", "clean_status": c1[0], "clean_out": c1[1]}
        if any(("<ROOT>" in l or "<TMP>" in l) and "\u2502" in l for l in (c1[1] + i1[1]).splitlines()):
            return {"ok": False, "why": "output prints a checkout path inside a table (path-length dependent)"}
        return {"ok": True, "clean_status": c1[0], "clean_out": c1[1], "injected_status": i1[0],
                "injected_out": i1[1][-4000:]}
    finally:
        shutil.rmtree(d, ignore_errors=True)


def fail_line(unit, detail):
    m = re.search(re.escape(unit) + r":(\d+)", detail or "")
    return int(m.group(1)) if m else None


def mechanical(clean_tree, injected_tree, failing, details):
    """Try each failing slt unit; return (reproducer dict or None, attempts list)."""
    attempts = []
    for u in failing:
        if u.startswith("cpp:"):
            attempts.append((u, "cpp unit")); continue
        ln = fail_line(u, details.get(u))
        if ln is None:
            # crash/timeout without a line: use the whole file
            ln = 10 ** 9
        for threads1 in (False, True):
            sql, why = make_from_slt(os.path.join(common.PRISTINE, u), ln, threads1)
            if not sql:
                attempts.append((u, why)); break
            v = verify(sql, clean_tree, injected_tree)
            attempts.append((u + (" [threads=1]" if threads1 else ""), "ok" if v["ok"] else v["why"]))
            if v["ok"]:
                v.update(sql=sql, source=u, method="mechanical")
                return v, attempts
            if "not deterministic" not in v["why"]:
                break
    return None, attempts
