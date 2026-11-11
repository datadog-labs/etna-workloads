cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r" repro.ml >"$d/out" 2>&1
grep -q "different arities" "$d/out" && { echo "ok: arity error"; rm -rf "$d"; exit 0; }
echo "BUG: wrong error"; head -3 "$d/out" | grep -v '^File'; rm -rf "$d"; exit 1
