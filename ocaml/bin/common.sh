# Shared settings for the bin/ scripts (sourced).
WORKLOAD=$(cd "$(dirname "$0")/.." && pwd)
RELEASE=5.5.2
UPSTREAM=${OCAML_UPSTREAM:-https://github.com/ocaml/ocaml.git}
CONFIGURE_FLAGS="--enable-ocamltest --enable-native-toplevel"
JOBS=${JOBS:-$(nproc 2>/dev/null || echo 4)}
bug_dir() {
  d="$WORKLOAD/bugs/$1"
  [ -d "$d" ] || { echo "unknown bug: $1 (see $WORKLOAD/bugs/)" >&2; exit 2; }
  echo "$d"
}
