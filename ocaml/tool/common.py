"""Shared configuration and helpers for the OCaml etna-style dataset tooling."""
import json, os, re, subprocess
from pathlib import Path

HOME = Path.home()
TOOLS = Path(__file__).resolve().parent
ROOT = TOOLS.parent                      # ~/ocaml-etna
WORK = HOME / "ocaml-etna-work"          # scratch
REPO = WORK / "ocaml"                    # upstream clone
DATA = WORK / "data"                     # intermediate results (json)
RELEASE = "5.5.2"

SCOPE_DIRS = ("parsing/", "typing/", "lambda/", "middle_end/", "asmcomp/",
              "backend/", "bytecomp/", "file_formats/", "utils/", "driver/",
              "runtime/", "stdlib/", "otherlibs/")
# Checked-in generated sources count as implementation.
GENERATED_IMPL = ("boot/menhir/parser.ml", "boot/menhir/parser.mli")
IMPL_EXT = re.compile(r"\.(ml|mli|mly|mll|c|h|S|asm|tbl|mlp|cppo|in)$")
NON_IMPL = re.compile(r"(^|/)(Changes|README[^/]*|.*\.md|.*\.adoc|.*\.txt|\.depend.*|Makefile[^/]*|dune|.*\.opam)$")


def is_impl(path):
    if path in GENERATED_IMPL:
        return True
    if not path.startswith(SCOPE_DIRS):
        return False
    if NON_IMPL.search(path):
        return False
    return bool(IMPL_EXT.search(path))


def is_test(path):
    return path.startswith("testsuite/")


def git(*args, cwd=REPO, check=True, input=None):
    r = subprocess.run(["git", "-c", "core.quotePath=false", *args], cwd=cwd, capture_output=True, text=True,
                       input=input, errors="replace")
    if check and r.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)}: {r.stderr}")
    return r.stdout


def load(name, default=None):
    p = DATA / name
    if not p.exists():
        return default
    return json.loads(p.read_text())


def save(name, obj):
    DATA.mkdir(parents=True, exist_ok=True)
    tmp = DATA / (name + ".tmp")
    tmp.write_text(json.dumps(obj, indent=1, sort_keys=True))
    os.replace(tmp, DATA / name)


# ---- disk guard: a full disk must never produce results -------------------------
ENOSPC_RE = re.compile(r"No space left on device|\bENOSPC\b|Disk quota exceeded|\[Errno 28\]")
MIN_FREE_GB = 15      # do not start a candidate below this
HARD_FREE_GB = 5      # anything finishing below this is suspect -> retryable


def free_gb(path=None):
    st = os.statvfs(path or WORK)
    return st.f_bavail * st.f_frsize / 2**30


def disk_wait(min_gb=MIN_FREE_GB):
    """Block (re-checking every 5 min) until there is enough free disk to start work."""
    import time
    warned = False
    while free_gb() < min_gb:
        if not warned:
            print(f"DISK LOW: {free_gb():.1f} GB free < {min_gb}; pausing", flush=True)
            warned = True
        time.sleep(300)


def disk_taint(res):
    """Mark a result retryable (never a result) if the disk ran out while it was produced."""
    blob = json.dumps(res)
    hit = ENOSPC_RE.search(blob)
    low = free_gb() < HARD_FREE_GB
    if hit or low:
        res["retryable"] = True
        res["retry_reason"] = "disk: " + (hit.group(0) if hit else f"{free_gb():.1f} GB free")
        res["gate"] = False
        if "anchor" in res:
            res["anchor"] = "retryable-disk"
    return res
