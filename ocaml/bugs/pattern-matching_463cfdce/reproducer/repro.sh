cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml 2>&1 | grep -c "must include a wild card"  > "$d/n"
n=$(cat "$d/n"); rm -rf "$d"
if [ "$n" -ge 1 ]; then echo "hint present"; exit 0; else echo "hint missing"; exit 1; fi
