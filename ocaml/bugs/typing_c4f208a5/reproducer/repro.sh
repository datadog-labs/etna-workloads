cd "$(dirname "$0")"
d=$(mktemp -d)
timeout 60 "$1/bin/ocamlc" -c -o "$d/r" repro.ml >"$d/out" 2>&1
if grep -q "cyclic" "$d/out" && ! grep -qi assert "$d/out"; then echo "ok: cyclic error"; rm -rf "$d"; exit 0; fi
echo "bug: unexpected compiler output"; rm -rf "$d"; exit 1
