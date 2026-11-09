#!/usr/bin/env python3
"""Reproducer harness. A reproducer is a directory with repro.sh plus inputs.
repro.sh runs with cwd = a fresh copy of the directory and env:
  TSC         path to built/local/tsc.js       (use: node "$TSC" ...)
  TYPESCRIPT  path to built/local/typescript.js (for API / language-service scripts)
Verified iff: the script is not version/fingerprint based; on the clean build two
runs give identical normalised output and exit status; and the injected build's
output or exit status differs.

Usage: repro.py CHECK REPRO_DIR CLEAN_ROOT INJECTED_ROOT [OUT.json]
"""
import json, os, re, shutil, sys, tempfile

sys.path.insert(0, os.path.dirname(__file__))
import proc, tstree

FORBIDDEN = re.compile(r"(--version|\b-v\b|\bversion\b|md5|sha\d*sum|cksum|\bstat\b|\bls\s+-l|"
                       r"readFileSync\([^)]*(TSC|TYPESCRIPT|tsc\.js|typescript\.js)|\$TSC\b[^\n]*\.map|"
                       r"\bdate\b|Math\.random|Date\.now|performance\.now|process\.hrtime)", re.I)


def run_once(repro_dir, root, tag, timeout=120):
    os.makedirs(inject_scratch(), exist_ok=True)
    td = tempfile.mkdtemp(dir=inject_scratch(), prefix=f"repro-{tag}-")
    try:
        cwd = os.path.join(td, "r")
        shutil.copytree(repro_dir, cwd, symlinks=False,
                        ignore=shutil.ignore_patterns("expected_*", "RATIONALE.md", "NOTES.md"))
        env = {"PATH": os.environ["PATH"], "HOME": td, "TMPDIR": td, "LANG": "C.UTF-8",
               "TSC": os.path.join(root, "built/local/tsc.js"),
               "TYPESCRIPT": os.path.join(root, "built/local/typescript.js"),
               "NODE_OPTIONS": "--max-old-space-size=2048"}
        log = os.path.join(td, "out.txt")
        rc, reason = proc.run(["bash", "repro.sh"], cwd, log, timeout=timeout, rss_mb=3072, env=env)
        out = open(log, "rb").read().decode(errors="replace")
        out = out.replace(os.path.realpath(root), "<TS>").replace(root, "<TS>")
        out = out.replace(os.path.realpath(cwd), "<CWD>").replace(cwd, "<CWD>").replace(td, "<TMP>")
        return {"rc": rc, "killed": reason, "out": out}
    finally:
        shutil.rmtree(td, ignore_errors=True)


def inject_scratch():
    return os.environ.get("ETNA_SCRATCH") or os.path.join(tstree.WORK, "scratch")


def check(repro_dir, clean_root, inj_root):
    script = open(os.path.join(repro_dir, "repro.sh")).read()
    extra = "".join(open(os.path.join(dp, f), errors="replace").read()
                    for dp, _, fs in os.walk(repro_dir) for f in fs
                    if f.endswith((".js", ".mjs", ".cjs", ".sh")) and f != "repro.sh")
    m = FORBIDDEN.search(script + extra)
    if m:
        return {"verified": False, "why": f"forbidden construct: {m.group(0)!r}"}
    c1 = run_once(repro_dir, clean_root, "c1")
    c2 = run_once(repro_dir, clean_root, "c2")
    i1 = run_once(repro_dir, inj_root, "i1")
    res = {"clean": c1, "clean2_same": (c1["rc"], c1["out"]) == (c2["rc"], c2["out"]), "injected": i1}
    if c1["killed"]:
        res.update(verified=False, why=f"clean run killed ({c1['killed']})")
    elif not res["clean2_same"]:
        res.update(verified=False, why="clean output not deterministic")
    elif (c1["rc"], c1["out"]) == (i1["rc"], i1["out"]):
        res.update(verified=False, why="no difference between clean and injected")
    else:
        res.update(verified=True, why="differs",
                   exit_differs=c1["rc"] != i1["rc"], output_differs=c1["out"] != i1["out"])
    return res


if __name__ == "__main__":
    _, cmd, rdir, clean, inj, *out = sys.argv
    r = check(rdir, clean, inj)
    s = json.dumps(r, indent=1)
    if out:
        open(out[0], "w").write(s)
    print(json.dumps({k: v for k, v in r.items() if k in ("verified", "why", "exit_differs", "output_differs")}))
