cd "$(dirname "$0")"
d=$(mktemp -d)
o=$("$1/bin/ocamlc" -w -8-11-12 -c -o "$d/r" repro.ml 2>&1); rm -rf "$d"
echo "$o"
case "$o" in *"(a, b) eq * a list"*) exit 0;; *) echo BUG; exit 1;; esac
