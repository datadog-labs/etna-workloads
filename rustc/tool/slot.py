#!/usr/bin/env python3
"""Build slots: fixed-path git worktrees of the release, each with its own build.

usage: slot.py create N     # create + build slot N (from scratch, never copied)
       slot.py status       # cleanliness of all slots
"""
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
from common import RELEASE, WORK, git  # noqa: E402
import runner  # noqa: E402

SLOTS = os.path.join(WORK, "slots")
CONFIG = """# rustc-etna build slot: same as base, but warnings are not fatal so that
# an injection that leaves e.g. an unused import still builds.
profile = "compiler"
change-id = "ignore"
[build]
compiler-docs = false
docs = false
extended = false
[rust]
debug-assertions = true
debug-logging = true
incremental = true
verbose-tests = true
download-rustc = false
deny-warnings = false
[llvm]
download-ci-llvm = true
assertions = false
"""


def path(n):
    return os.path.join(SLOTS, f"s{n}")


def create(n):
    p = path(n)
    os.makedirs(SLOTS, exist_ok=True)
    if not os.path.exists(p):
        git("worktree", "add", "--detach", p, RELEASE)
    with open(os.path.join(p, "bootstrap.toml"), "w") as f:
        f.write(CONFIG)
    # Tests run under a private tmp inside the slot's own build dir.
    code, secs = runner.build_library(p, os.path.join(SLOTS, f"s{n}-build.log"))
    print(f"slot {n}: build exit {code} in {secs:.0f}s")
    return code == 0


def dirty(slot):
    """Files differing from the release (tracked or untracked), ignoring build/ and config."""
    out = subprocess.run(["git", "status", "--porcelain", "--untracked-files=all"],
                         cwd=slot, capture_output=True, text=True).stdout
    return [line for line in out.splitlines()
            if not line[3:].startswith(("build/", "bootstrap.toml"))]


def head_ok(slot):
    h = subprocess.run(["git", "rev-parse", "HEAD"], cwd=slot, capture_output=True, text=True).stdout.strip()
    return h == git("rev-parse", f"{RELEASE}^{{commit}}").strip()


def reset(slot):
    """Restore the whole slot source to the release.  Agents should only edit
    compiler/, but a stray edit elsewhere (tests/, a notes file) must not leak
    into later candidates.  build/ and bootstrap.toml are ignored by git and kept."""
    subprocess.run(["git", "checkout", "-q", "--", "."], cwd=slot, check=True)
    subprocess.run(["git", "clean", "-qfd"], cwd=slot, check=True)


if __name__ == "__main__":
    if sys.argv[1] == "create":
        sys.exit(0 if create(int(sys.argv[2])) else 1)
    elif sys.argv[1] == "status":
        for d in sorted(os.listdir(SLOTS)):
            if os.path.isdir(os.path.join(SLOTS, d)):
                s = os.path.join(SLOTS, d)
                print(d, "head_ok" if head_ok(s) else "HEAD MOVED", dirty(s)[:5])
