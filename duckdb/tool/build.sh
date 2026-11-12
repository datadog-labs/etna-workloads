#!/bin/bash
# Build a DuckDB source tree the way the project builds it for its own tests:
# `make relassert` (RelWithDebInfo + FORCE_ASSERT, ASan+UBSan on), Ninja, ccache,
# plus the tpch/tpcds extensions that many tests `require`.
# Two speed knobs, both project-provided and behaviour-neutral:
#   REDUCE_SYMBOLS=1  (-g1 -gsplit-dwarf instead of -g: smaller objects, much faster links)
#   only the `unittest` and `shell` (duckdb) targets are built (wrapper appends --target).
# usage: build.sh SRC_DIR [VERSION_STRING]
set -eo pipefail
SRC=$1; VER=${2:-v2.0.0}
HERE=$(cd "$(dirname "$0")" && pwd)
cd "$SRC"
export GEN=ninja
export OVERRIDE_GIT_DESCRIBE="$VER"
export BUILD_EXTENSIONS="${BUILD_EXTENSIONS-tpch;tpcds}"
export CCACHE_DIR="${CCACHE_DIR:-${ETNA_WORK:-$HOME/duckdb-etna-work}/ccache}"
export CCACHE_BASEDIR="$SRC"
export CCACHE_NOHASHDIR=1   # share cache entries across fixed-path slots (only debug-info paths differ)
# lld through the project's DUCKDB_LINKER option (its CI uses mold): same objects and flags, links ~6x faster
export DUCKDB_LINKER="${DUCKDB_LINKER-lld}"
export CMAKE_VARS_BUILD="-DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DREDUCE_SYMBOLS=1 -DDUCKDB_LINKER=${DUCKDB_LINKER}"
# 3 compile jobs per build: up to ~7 builds run at once (3 verbatim, 2 agents, anchor, repro) and an ASan
# unity compile takes 1.5-2.5 GB, so -j16 each drove the 62 GB host into swap
export CMAKE_BUILD_PARALLEL_LEVEL="${JOBS:-5}"
exec make relassert NINJA_BUILD_WRAPPER="$HERE/targets_wrapper.sh"
