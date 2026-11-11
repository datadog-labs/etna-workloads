cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w -a -rectypes -c -o "$d/x" repro.ml >"$d/o" 2>&1
grep -q "alias is bound" "$d/o" && { echo "correct error"; rm -rf "$d"; exit 0; }
echo "wrong error"; rm -rf "$d"; exit 1
