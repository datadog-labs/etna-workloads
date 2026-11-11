"""Injection construction and the gate.

gate(slot, cand, patch_text) -> result dict:
  applies, reversible (byte-for-byte), build, failing oracle cases (fail in both runs).
"""
import json, os, re, shutil, subprocess, tempfile, time
from pathlib import Path
from common import *
from slots import Slot, RELEASE_SRC

PATCH_DIR = DATA / "patches"
SCRATCH = WORK / "scratch"


def patch_files(patch_text):
    files = set()
    for m in re.finditer(r"^diff --git a/(\S+) b/(\S+)", patch_text, re.M):
        files.update([m.group(1), m.group(2)])
    return sorted(files)


def make_tmp(prefix):
    SCRATCH.mkdir(parents=True, exist_ok=True)
    return Path(tempfile.mkdtemp(prefix=prefix, dir=SCRATCH))


def copy_from_release(paths, dst):
    for p in paths:
        s = RELEASE_SRC / p
        if s.is_file():
            (dst / p).parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(s, dst / p)
            os.chmod(dst / p, 0o644)


def diff_trees(paths, a, b):
    """Forward patch a -> b restricted to paths, with a/ b/ prefixes."""
    tmp = make_tmp("diff-")
    try:
        for side, root in (("a", a), ("b", b)):
            (tmp / side).mkdir()
            for p in paths:
                if (root / p).is_file():
                    (tmp / side / p).parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(root / p, tmp / side / p)
        r = subprocess.run(["git", "diff", "--no-index", "--binary", "--no-renames",
                            "--src-prefix=", "--dst-prefix=", "a", "b"],
                           cwd=tmp, capture_output=True, text=True, errors="surrogateescape")
        return r.stdout
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def verbatim_injection(cand):
    """Reverse the fix's implementation hunks on the release. -> (patch, mode) or (None, why)."""
    d = git("diff", "--binary", "--no-renames", f"{cand['sha']}^", cand["sha"], "--", *cand["impl_files"])
    files = patch_files(d)
    tmp = make_tmp("inj-")
    try:
        copy_from_release(files, tmp)
        r = subprocess.run(["git", "apply", "-R", "-"], cwd=tmp, input=d, text=True, capture_output=True)
        mode = "exact"
        if r.returncode != 0:
            copy_from_release(files, tmp)
            r = subprocess.run(["patch", "-p1", "-R", "--batch", "-F3", "--no-backup-if-mismatch",
                                "-r", "-"], cwd=tmp, input=d, text=True, capture_output=True)
            mode = "fuzz"
            if r.returncode != 0:
                return None, "conflict"
        inj = diff_trees(files, RELEASE_SRC, tmp)
        if not inj.strip():
            return None, "empty"
        return inj, mode
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def check_reversible(inj):
    files = patch_files(inj)
    tmp = make_tmp("rev-")
    try:
        copy_from_release(files, tmp)
        if subprocess.run(["git", "apply", "-"], cwd=tmp, input=inj, text=True, capture_output=True).returncode:
            return False
        if subprocess.run(["git", "apply", "-R", "-"], cwd=tmp, input=inj, text=True, capture_output=True).returncode:
            return False
        for p in files:
            a, b = RELEASE_SRC / p, tmp / p
            if a.is_file() != b.is_file():
                return False
            if a.is_file() and a.read_bytes() != b.read_bytes():
                return False
        return True
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def oracle_for(sha):
    m = load_cached("testmap.json")[sha]["units"]
    base = load_cached("base.json")
    return [u for u in m if base.get(u, {}).get("run1") == "passed" and base[u].get("run2") == "passed"]


_cache = {}
def load_cached(name):
    if name not in _cache:
        _cache[name] = load(name)
    return _cache[name]


def gate(slot, inj, oracle, log_name):
    """Apply inj in a reset slot, build, run oracle twice. Leaves slot dirty (caller resets)."""
    res = dict(files=patch_files(inj), oracle=oracle)
    null = not inj.strip()          # control run: unmodified release
    res["reversible"] = True if null else check_reversible(inj)
    slot.reset()
    slot.log = slot.root / f"{log_name}.build.log"
    if slot.log.exists():
        slot.log.unlink()
    r = subprocess.run(["git", "apply", "-"], cwd=slot.src, input=inj, text=True, capture_output=True) \
        if not null else subprocess.CompletedProcess([], 0, "", "")
    res["applies"] = r.returncode == 0
    if not res["applies"]:
        res["apply_err"] = r.stderr[-1000:]
        return res
    if any(f.endswith(".in") for f in res["files"]):
        subprocess.run(["./config.status"], cwd=slot.src, capture_output=True)
    t = time.time()
    res["build"] = slot.build(clean=True)
    res["build_secs"] = round(time.time() - t)
    if res["build"] != "ok":
        res["build_log_tail"] = slot.log.read_text(errors="replace")[-3000:]
        slot.log.unlink(missing_ok=True)
        return res
    runs = []
    for k in (1, 2):
        runs.append(slot.run_units(oracle, tag=f"inj{k}"))
    res["runs"] = [{u: st for u, (st, _) in r.items()} for r in runs]
    res["failing"] = [u for u in oracle if runs[0][u][0] != "passed" and runs[1][u][0] != "passed"]
    res["flaky_inj"] = [u for u in oracle if (runs[0][u][0] == "passed") != (runs[1][u][0] == "passed")]
    res["fail_detail"] = {u: runs[0][u][1][-1500:] for u in res["failing"]}
    slot.log.unlink(missing_ok=True)
    return res


def passes_gate(res):
    return bool(res.get("applies") and res.get("reversible") and res.get("build") == "ok" and res.get("failing"))
