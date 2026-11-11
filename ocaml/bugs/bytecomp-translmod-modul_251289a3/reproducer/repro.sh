cd "$(dirname "$0")"
out=$(timeout 60 "$1/bin/ocaml" repro.ml 2>&1)
if [ "$out" = "3 ok" ]; then echo "$out"; exit 0; fi
echo "BUG: wrong output"; exit 1
