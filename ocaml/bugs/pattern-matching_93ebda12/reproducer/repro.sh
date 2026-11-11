cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/r.cmo" repro.ml 2>&1 | grep -c "extensible variant types" > "$d/n"
if [ "$(cat $d/n)" = 1 ]; then rm -rf "$d"; echo ok; exit 0; fi
rm -rf "$d"; echo "wrong warning message"; exit 1
