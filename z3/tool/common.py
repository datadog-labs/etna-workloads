"""Shared config for the Z3 etna-style dataset tooling (clean-room)."""
import os, re, subprocess
HOME = os.path.expanduser("~")
WORK = os.environ.get("Z3_ETNA_WORK", os.path.join(HOME, "z3-etna-work"))   # scratch (clones, builds, slots)
REPO = os.path.join(WORK, "z3")
RELEASE = "z3-5.3.3"
DATA = os.environ.get("Z3_ETNA_DATA", os.path.join(HOME, "z3-etna", "data"))  # results

BINDING_DIRS = ("src/api/python/", "src/api/java/", "src/api/dotnet/", "src/api/js/",
                "src/api/ml/", "src/api/julia/", "src/api/go/", "src/api/mcp/", "src/api/c++/")
IMPL_EXT = (".cpp", ".h", ".c", ".hpp", ".pyg")

def is_test(path):
    return path.startswith("src/test/")

def is_impl(path):
    if not path.startswith("src/") or is_test(path):
        return False
    if path.startswith(BINDING_DIRS):
        return False
    return path.endswith(IMPL_EXT)

def git(*args, cwd=REPO, check=True, input=None):
    r = subprocess.run(["git", *args], cwd=cwd, capture_output=True, text=True,
                       input=input, errors="replace")
    if check and r.returncode != 0:
        raise RuntimeError(f"git {args}: {r.stderr}")
    return r.stdout

ISSUE_RE = re.compile(r"(?i)\b(?:fix(?:es|ed)?|close[sd]?|resolve[sd]?|issue|gh)[\s:-]*#(\d+)")
BARE_ISSUE_RE = re.compile(r"(?<![(\w])#(\d{3,5})\b(?!\))")
FIX_WORD_RE = re.compile(r"(?i)\b(fix(e[sd])?|bug(fix)?|crash(es)?|segfault|unsound(ness)?|soundness|"
                         r"incorrect|wrong|regression|assert(ion)?\s+(violation|fail)|"
                         r"overflow|leak|hang|incomplete model|invalid model|false (sat|unsat))\b")
PR_RE = re.compile(r"\(#(\d+)\)\s*$")
