cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w +A-70 -c -o "$d/r.cmo" repro.ml 2>&1 | grep -c "constructor A" > "$d/n"
n=$(cat "$d/n"); rm -rf "$d"
if [ "$n" = 0 ]; then echo ok; exit 0; else echo "bad: spurious warning for A"; exit 1; fi
