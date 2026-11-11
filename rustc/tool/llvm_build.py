#!/usr/bin/env python3
"""LLVM for anchor builds whose CI LLVM artifacts are gone.

For a rust commit, take the src/llvm-project submodule commit, fetch it
(shallow) from rust-lang/llvm-project, read its major version, and return an
llvm-config of that major version:
one built once per major version from the first submodule commit
that needed it (rust's own fork, so its wrapper compiles against it).
The system LLVM is not used (see llvm_config_for).
"""
import fcntl
import os
import re
import shutil
import subprocess
import sys


sys.path.insert(0, os.path.dirname(__file__))
from common import WORK, git  # noqa: E402
import runner  # noqa: E402

LLVM = os.path.join(WORK, "llvm")
SRC_GIT = os.path.join(LLVM, "src.git")
URL = "https://github.com/rust-lang/llvm-project.git"
TARGETS = "X86;AArch64;ARM;RISCV;PowerPC;WebAssembly"


def sh(cmd, cwd=None, log=None):
    if log:
        with open(log, "ab") as f:
            return subprocess.run(cmd, cwd=cwd, stdout=f, stderr=subprocess.STDOUT).returncode
    return subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)


def submodule_sha(commit):
    out = git("ls-tree", commit, "src/llvm-project").split()
    return out[2] if len(out) >= 3 else None


def _init():
    if not os.path.exists(SRC_GIT):
        os.makedirs(LLVM, exist_ok=True)
        sh(["git", "init", "-q", "--bare", SRC_GIT])
    if sh(["git", "remote", "get-url", "origin"], cwd=SRC_GIT).returncode != 0:
        sh(["git", "remote", "add", "origin", URL], cwd=SRC_GIT)
        sh(["git", "config", "remote.origin.promisor", "true"], cwd=SRC_GIT)
        sh(["git", "config", "remote.origin.partialclonefilter", "blob:none"], cwd=SRC_GIT)


def fetch_meta(sha):
    """Commit + trees only (blobs fetched lazily): enough to read the version."""
    _init()
    if sh(["git", "cat-file", "-e", sha], cwd=SRC_GIT).returncode != 0:
        r = sh(["git", "fetch", "-q", "--depth", "1", "--filter=blob:none", "origin", sha], cwd=SRC_GIT)
        if r.returncode:
            raise RuntimeError("llvm fetch failed: " + r.stderr[-500:])


def fetch_full(sha):
    _init()
    r = sh(["git", "fetch", "-q", "--depth", "1", "--refetch", "origin", sha], cwd=SRC_GIT)
    if r.returncode:
        raise RuntimeError("llvm full fetch failed: " + r.stderr[-500:])


def major(sha):
    for path in ("cmake/Modules/LLVMVersion.cmake", "llvm/CMakeLists.txt"):
        r = sh(["git", "show", f"{sha}:{path}"], cwd=SRC_GIT)
        if r.returncode == 0:
            m = re.search(r"set\(LLVM_VERSION_MAJOR\s+(\d+)", r.stdout)
            if m:
                return int(m.group(1))
    raise RuntimeError("cannot read LLVM version")


def build(sha, maj):
    d = os.path.join(LLVM, str(maj))
    inst = os.path.join(d, "install")
    cfg = os.path.join(inst, "bin", "llvm-config")
    if os.path.exists(cfg):
        return cfg
    os.makedirs(d, exist_ok=True)
    log = os.path.join(d, "build.log")
    src = os.path.join(d, "src")
    if not os.path.exists(src):
        fetch_full(sha)
        os.makedirs(src)
        p1 = subprocess.Popen(["git", "archive", sha], cwd=SRC_GIT, stdout=subprocess.PIPE)
        subprocess.run(["tar", "-x", "-C", src], stdin=p1.stdout, check=True)
        p1.wait()
        open(os.path.join(d, "SOURCE_COMMIT"), "w").write(sha + "\n")
    b = os.path.join(d, "build")
    rc = sh(["cmake", "-G", "Ninja", "-S", os.path.join(src, "llvm"), "-B", b,
             "-DCMAKE_BUILD_TYPE=Release", "-DLLVM_ENABLE_ASSERTIONS=OFF",
             f"-DLLVM_TARGETS_TO_BUILD={TARGETS}", "-DLLVM_INCLUDE_TESTS=OFF",
             "-DLLVM_INCLUDE_EXAMPLES=OFF", "-DLLVM_INCLUDE_BENCHMARKS=OFF", "-DLLVM_INCLUDE_DOCS=OFF",
             "-DLLVM_ENABLE_ZLIB=OFF", "-DLLVM_ENABLE_ZSTD=OFF", "-DLLVM_ENABLE_LIBXML2=OFF",
             "-DLLVM_ENABLE_TERMINFO=OFF", "-DLLVM_ENABLE_LIBEDIT=OFF", "-DLLVM_INSTALL_UTILS=ON",
             "-DLLVM_CCACHE_BUILD=ON", f"-DCMAKE_INSTALL_PREFIX={inst}",
             # GCC 13 no longer pulls <cstdint> in transitively; older LLVM sources need it.
             "-DCMAKE_CXX_FLAGS=-include cstdint"], log=log)
    if rc == 0:
        rc, _ = runner.run(["ninja", "-C", b, "install"], b, log, 6 * 3600, kind="llvm")
    if rc != 0 or not os.path.exists(cfg):
        raise RuntimeError(f"LLVM {maj} build failed, see {log}")
    shutil.rmtree(b, ignore_errors=True)  # keep only install/ (disk)
    shutil.rmtree(src, ignore_errors=True)
    # FileCheck is installed by LLVM_INSTALL_UTILS
    return cfg


def llvm_config_for(commit):
    """Returns (llvm-config path, FileCheck path, description)."""
    sha = submodule_sha(commit)
    if not sha:
        raise RuntimeError("no llvm submodule entry")
    os.makedirs(LLVM, exist_ok=True)
    with open(os.path.join(LLVM, ".lock"), "w") as lk:
        fcntl.flock(lk, fcntl.LOCK_EX)
        fetch_meta(sha)
        maj = major(sha)
        # The system LLVM 20 is not used: it links libzstd, whose development files
        # are not installed here (90 anchors failed with "cannot find -lzstd").
        cfg = build(sha, maj)
    return cfg, os.path.join(os.path.dirname(cfg), "FileCheck"), f"built-llvm-{maj}"


if __name__ == "__main__":
    print(llvm_config_for(sys.argv[1]))
