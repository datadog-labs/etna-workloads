"""Shared paths and helpers for the DuckDB etna pipeline."""
import json, os, re, subprocess, time

HOME = os.path.expanduser("~")
TOOL = os.path.dirname(os.path.abspath(__file__))
WORK = os.environ.get("ETNA_WORK", os.path.join(HOME, "duckdb-etna-work"))
UPSTREAM = os.path.join(WORK, "upstream")
PRISTINE = os.path.join(WORK, "pristine")          # read-only git archive of the release
BASE = os.path.join(WORK, "slots/base/src")         # read-only built release (base runs)
RELEASE = "v2.0.0"
RESULTS = os.path.join(WORK, "results")


def sh(cmd, **kw):
    kw.setdefault("capture_output", True)
    return subprocess.run(cmd, **kw)


def load_jsonl(path):
    return [json.loads(l) for l in open(path)] if os.path.exists(path) else []


def candidates():
    return load_jsonl(os.path.join(WORK, "candidates.jsonl"))


def units_map():
    return {r["sha"]: r for r in load_jsonl(os.path.join(WORK, "units.jsonl"))}


def impl_diff(sha, parent):
    """The fix's implementation diff (SCOPE = src/), parent -> fix."""
    return sh(["git", "-C", UPSTREAM, "diff", "--no-renames", "--binary", parent, sha, "--", "src/"], check=True).stdout


def sync_tree(dst, src=PRISTINE):
    """Make dst/ (minus build/) equal to src by content; never keep times (so ninja sees changes)."""
    r = sh(["rsync", "-rlpc", "--chmod=u+w", "--delete", "--exclude=/build/", "--exclude=/duckdb_unittest_tempdir/",
            src.rstrip("/") + "/", dst.rstrip("/") + "/"])
    if r.returncode != 0:
        raise RuntimeError("rsync failed: " + r.stderr.decode()[-500:])


def tree_diff(a, b, sub="src"):
    """Unified diff of a/sub vs b/sub with a/ b/ prefixes (an injection patch)."""
    r = sh(["git", "diff", "--no-index", "--no-renames", "--binary", "--no-color",
            os.path.join(a, sub), os.path.join(b, sub)])
    out = r.stdout.decode("utf-8", "surrogateescape")
    # rewrite absolute prefixes to a/src/... b/src/...
    out = out.replace("a" + os.path.join(a, sub), "a/" + sub).replace("b" + os.path.join(b, sub), "b/" + sub)
    out = out.replace("a" + os.path.join(b, sub), "a/" + sub).replace("b" + os.path.join(a, sub), "b/" + sub)
    return out.encode("utf-8", "surrogateescape")


def same_tree(a, b, sub="src"):
    return sh(["diff", "-rq", "--no-dereference", os.path.join(a, sub), os.path.join(b, sub)]).returncode == 0


def write_json(path, obj):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    tmp = path + ".tmp"
    with open(tmp, "w") as f:
        json.dump(obj, f, indent=1)
    os.replace(tmp, path)


def base_oracle():
    """{unit: 'pass'} for units that passed in both base runs; other outcomes as recorded."""
    runs = [json.load(open(os.path.join(RESULTS, "base", f"run{i}.json"))) for i in (1, 2)]
    out = {}
    for u in runs[0]:
        o = [r.get(u, {}).get("outcome") for r in runs]
        out[u] = "pass" if all(x == "pass" for x in o) else ("flaky" if "pass" in o else (o[0] or "missing"))
    return out
