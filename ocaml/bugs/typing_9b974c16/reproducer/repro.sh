cd "$(dirname "$0")"
out=$(timeout 60 "$1/bin/ocaml" -w -a repro.ml 2>&1)
echo "$out"
[ "$out" = match_failure ] || { echo BUG; exit 1; }
