cd "$(dirname "$0")"
if "$1/bin/ocamlc" -c -o "${TMPDIR:-/tmp}/reprox" repro.ml >/dev/null 2>&1; then
  echo "accepted invalid program"; rm -f "${TMPDIR:-/tmp}"/reprox.*; exit 1
fi
echo "rejected as expected"
