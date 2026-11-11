cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w -a repro.ml -o "$d/r" && "$d/r" > "$d/out"
printf 'c argument\na argument\nf defined\nb argument\na parameter\nb parameter\nc parameter\n' > "$d/exp"
if cmp -s "$d/out" "$d/exp"; then echo ok; rc=0; else echo BUG; rc=1; fi
rm -rf "$d"; exit $rc
