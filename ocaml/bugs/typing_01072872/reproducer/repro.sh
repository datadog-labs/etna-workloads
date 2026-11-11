cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r" repro.ml 2>"$d/e"
grep -c "There is no field" "$d/e" >"$d/n"
n=$(cat "$d/n")
rm -rf "$d"
if [ "$n" -ge 1 ]; then echo "ok message"; exit 0; else echo "wrong message"; exit 1; fi
