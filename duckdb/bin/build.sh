#!/bin/bash
# Build a DuckDB checkout the way this dataset was verified:
#   make relassert (RelWithDebInfo + assertions, ASan+UBSan), Ninja, tpch/tpcds extensions,
#   REDUCE_SYMBOLS=1, lld, only the `unittest` and `shell` targets.
# usage: bin/build.sh DUCKDB_DIR
set -eo pipefail
SRC=$(cd "$1" && pwd)
HERE=$(cd "$(dirname "$0")" && pwd)
cd "$SRC"
export GEN=ninja OVERRIDE_GIT_DESCRIBE=v2.0.0 BUILD_EXTENSIONS="tpch;tpcds"
LINKER=$(command -v ld.lld >/dev/null && echo lld || echo "")
export CMAKE_VARS_BUILD="-DREDUCE_SYMBOLS=1 ${LINKER:+-DDUCKDB_LINKER=$LINKER} ${EXTRA_CMAKE_VARS:-}"
exec make relassert NINJA_BUILD_WRAPPER="$HERE/_targets.sh"
