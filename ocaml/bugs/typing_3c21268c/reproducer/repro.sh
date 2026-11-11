cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w +42 -c repro.ml -o "$d/r.cmo" 2>&1 | grep -c "relies on type-directed" > "$d/n"
n=$(cat "$d/n"); rm -rf "$d"
if [ "$n" -ge 1 ]; then echo "message ok"; exit 0; else echo "message wrong"; exit 1; fi
