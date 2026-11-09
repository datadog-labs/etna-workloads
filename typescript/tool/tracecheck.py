#!/usr/bin/env python3
"""Heuristic hunk-trace check: flag injection hunks whose changed lines share no
identifier (len>=4, not a keyword) with the fix's changed implementation lines."""
import json, os, re, subprocess, sys
W = os.path.expanduser("~/ts-etna-work")
KW = set("const return true false undefined function export import type this case break else from null void".split())
ids = lambda s: {t for t in re.findall(r"[A-Za-z_]\w{3,}", s) if t not in KW}

def hunks(patch):
    out, cur = [], None
    for l in patch.replace("\r", "").split("\n"):
        if l.startswith("@@"):
            cur = []; out.append(cur)
        elif cur is not None and l[:1] in "+-" and not l.startswith(("+++", "---")):
            cur.append(l[1:])
    return [h for h in out if any(x.strip() for x in h)]

def check(d, cands):
    s = d.rstrip("/").split("/")[-1]; c = cands[s]
    fix = subprocess.run(["git", "-C", f"{W}/ts", "diff", c["sha"] + "^", c["sha"], "--", *c["impl_files"]],
                         capture_output=True, text=True, errors="replace").stdout
    fx = set().union(*[ids("\n".join(h)) for h in hunks(fix)] or [set()])
    inj = open(f"{d}/injection.patch", errors="replace").read()
    return [i for i, h in enumerate(hunks(inj)) if ids("\n".join(h)) and not (ids("\n".join(h)) & fx)]

if __name__ == "__main__":
    cands = {c["sha"][:12]: c for c in map(json.loads, open(f"{W}/candidates.jsonl"))}
    for d in sys.argv[1:]:
        bad = check(d, cands)
        if bad: print(d, "untraced hunks:", bad)
