cd "$(dirname "$0")"
out=$("$1/bin/ocaml" repro.ml)
echo "$out"
[ "$out" = "[1]
[2]" ] || exit 1
