cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/r.ml"
(cd "$d" && "$1/bin/ocamlc" -o a r.ml) || { rm -rf "$d"; exit 1; }
"$d/a" > "$d/out"
if [ "$(tr '\n' ' ' < "$d/out")" = "Before class Class init After class " ]; then rm -rf "$d"; echo correct; exit 0; fi
rm -rf "$d"; echo wrong order; exit 1
