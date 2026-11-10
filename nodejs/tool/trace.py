#!/usr/bin/env python3
"""Content trace of an injection to its fix: how much of the injection is the fix, reversed.

trace = fraction of the injection's changed lines (whitespace-normalised, trivial lines
dropped) that appear among the fix's changed lines in the opposite direction
(injection '+' lines among the fix's '-' lines and vice versa).
Path locality misses moved code (lib/repl.js -> lib/internal/repl/completion.js);
this catches it, and flags injections that re-create a symptom elsewhere (trace ~ 0).
"""
import os, re, subprocess

REPO = os.path.expanduser("~/node-etna-work/node")
TRIVIAL = re.compile(r"^[\s{}();,\[\]]*$|^\s*(//|/\*|\*)")


def changed(diff):
    plus, minus = set(), set()
    for line in diff.splitlines():
        if line.startswith(("+++", "---")):
            continue
        if line[:1] in "+-":
            s = re.sub(r"\s+", " ", line[1:]).strip()
            if not s or TRIVIAL.match(s):
                continue
            (plus if line[0] == "+" else minus).add(s)
    return plus, minus


def trace(sha, injection, impl_files):
    fix = subprocess.run(["git", "-C", REPO, "show", "--format=", sha, "--", *impl_files],
                         capture_output=True, text=True, errors="replace").stdout
    fp, fm = changed(fix)
    ip, im = changed(injection)
    lines = len(ip) + len(im)
    if not lines:
        return None
    hit = len(ip & fm) + len(im & fp)
    return round(hit / lines, 3)


IDENT = re.compile(r"[A-Za-z_$][A-Za-z0-9_$]{2,}")
STOP = {"const", "let", "var", "return", "function", "if", "else", "this", "true", "false", "null",
        "undefined", "new", "throw", "for", "while", "auto", "void", "int", "bool", "static", "args",
        "env", "isolate", "nullptr", "break", "case", "continue"}


def tokens(lines):
    out = set()
    for s in lines:
        out |= {t for t in IDENT.findall(s) if t not in STOP}
    return out


def token_trace(sha, injection, impl_files):
    """Share of identifiers in the injection's changed lines that occur in the fix's changed lines."""
    fix = subprocess.run(["git", "-C", REPO, "show", "--format=", sha, "--", *impl_files],
                         capture_output=True, text=True, errors="replace").stdout
    fp, fm = changed(fix)
    ip, im = changed(injection)
    it = tokens(ip | im)
    if not it:
        return None
    return round(len(it & tokens(fp | fm)) / len(it), 3)
