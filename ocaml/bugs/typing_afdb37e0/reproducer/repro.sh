cd "$(dirname "$0")"
out=$(timeout 60 "$1/bin/ocamlc" -i repro.ml 2>&1); rc=$?
echo "$out" | head -5
[ $rc -eq 0 ] || { echo BUG; exit 1; }
