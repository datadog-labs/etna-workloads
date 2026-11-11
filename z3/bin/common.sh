# shared settings for the z3 workload scripts
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${Z3_ETNA_SRC:-$ROOT/z3-src}"
BUILD="$SRC/build-etna"
RELEASE_TAG=z3-5.3.3
RELEASE_SHA=430d19e697e2ec9bad79ff210d41b4a7a5fcfa3e
MEM_KB=${Z3_ETNA_MEM_KB:-8000000}
bugdir() { local b="$ROOT/bugs/$1"; [ -d "$b" ] || { echo "unknown bug: $1" >&2; exit 2; }; echo "$b"; }
# run a command in its own process group with memory and time limits; kills the whole group on timeout
limited() { local t=$1; shift; ( ulimit -v "$MEM_KB"; exec timeout -s KILL "$t" setsid "$@" ); }
