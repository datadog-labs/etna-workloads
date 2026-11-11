cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlc" -I +unix unix.cma "$d/repro.ml" -o "$d/r" 2>/dev/null || "$1/bin/ocamlc" -I +unix unix.cma "$d/repro.ml" -o "$d/r" || { rm -rf "$d"; exit 1; }
timeout 20 "$d/r"; rc=$?
rm -rf "$d"; [ $rc -eq 0 ] || exit 1
