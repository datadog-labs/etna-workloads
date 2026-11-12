#!/bin/bash
# Fetch DuckDB v2.0.0 into DIR (a git checkout, so bugs can be applied and reverted) and build it.
# usage: bin/setup_release.sh DIR
set -eo pipefail
DIR=$1
[ -n "$DIR" ] || { echo "usage: $0 DIR" >&2; exit 2; }
git clone --quiet --depth 1 --branch v2.0.0 https://github.com/duckdb/duckdb.git "$DIR"
test "$(git -C "$DIR" rev-parse HEAD)" = d54cbbe3df17e8e5ce68312f483b4155836112aa
"$(dirname "$0")/build.sh" "$DIR"
