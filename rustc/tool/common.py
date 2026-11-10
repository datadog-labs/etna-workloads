"""Shared paths and helpers for the rustc etna tooling."""
import os
import re
import subprocess

HOME = os.path.expanduser("~")
ROOT = os.path.join(HOME, "rustc-etna")
WORK = os.path.join(HOME, "rustc-etna-work")
REPO = os.path.join(WORK, "rust.git-src")
DATA = os.path.join(ROOT, "data")
RELEASE = "1.99.1"
SINCE = "2020-08-01"  # compiler/ directory exists from 2020-08-30

# Test suites that compiletest can use as oracles.
ORACLE_SUITES = {"ui", "crashes", "mir-opt", "codegen", "codegen-llvm",
                 "codegen-units", "incremental", "assembly", "assembly-llvm"}


def git(*args, cwd=REPO, check=True, input=None):
    r = subprocess.run(["git", *args], cwd=cwd, capture_output=True,
                       input=input, check=False)
    if check and r.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)}: {r.stderr.decode(errors='replace')}")
    return r.stdout.decode(errors="replace")


def is_test_only_impl(path):
    """Test-only code inside compiler/ (unit tests, benches)."""
    parts = path.split("/")
    name = parts[-1]
    if name in ("tests.rs", "test.rs") or name.endswith("_tests.rs"):
        return True
    if "tests" in parts[:-1] or "benches" in parts[:-1]:
        return True
    return False


IMPL_EXT = (".rs", ".ftl", ".c", ".cpp", ".h", ".hpp", ".def", ".json")


def is_impl(path):
    """Implementation file in SCOPE (compiler/ rustc_* crates)."""
    if not path.startswith("compiler/"):
        return False
    if is_test_only_impl(path):
        return False
    name = path.rsplit("/", 1)[-1]
    if name in ("Cargo.toml", "build.rs", "README.md") or name.endswith(".md"):
        return False
    return path.endswith(IMPL_EXT)


def test_suite(path):
    """Return compiletest suite name for a test path, or None."""
    m = re.match(r"(?:tests|src/test)/([^/]+)/", path)
    return m.group(1) if m else None


INFRA_PATTERNS = ("No space left on device", "os error 28", "ENOSPC", "Disk quota exceeded")


class InfraError(Exception):
    """An environment failure (e.g. disk full): never recorded as a result."""


def save_result(path, res):
    """Write a result record unless it shows an infrastructure failure; such
    records go to data/infra-errors/ for inspection and InfraError is raised."""
    import json as _json
    text = _json.dumps(res, indent=1)
    if any(p in text for p in INFRA_PATTERNS):
        d = os.path.join(DATA, "infra-errors")
        os.makedirs(d, exist_ok=True)
        with open(os.path.join(d, os.path.basename(path)), "w") as f:
            f.write(text)
        raise InfraError(f"infrastructure failure in {path}")
    with open(path + ".tmp", "w") as f:
        f.write(text)
    os.replace(path + ".tmp", path)
