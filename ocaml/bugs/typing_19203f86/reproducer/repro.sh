cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -w +A -c -o /dev/null repro.ml 2>&1)
d=$(mktemp -d); out=$(cd "$d" && cp "$OLDPWD/repro.ml" . && "$1/bin/ocamlc" -w +A -c repro.ml 2>&1 | grep -c "Alert deprecated"); rm -rf "$d"
echo "deprecated alerts: $out"
[ "$out" = 1 ] 
