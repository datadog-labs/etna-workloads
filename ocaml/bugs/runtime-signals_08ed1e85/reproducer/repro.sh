cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlopt" -I +unix unix.cmxa threads.cmxa -I +threads repro.ml -o "$d/r" 2>&1 >/dev/null || { rm -rf "$d"; echo compile fail; exit 1; }
"$d/r"; r=$?
rm -rf "$d"; exit $r
