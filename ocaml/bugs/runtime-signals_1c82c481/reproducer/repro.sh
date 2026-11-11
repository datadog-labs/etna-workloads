cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlopt" -I +unix -I +threads unix.cmxa threads.cmxa repro.ml -o "$d/r" >/dev/null 2>&1 || { rm -rf "$d"; echo compile fail; exit 1; }
out=$(timeout 60 "$d/r"); rm -rf "$d"
echo "$out"
[ "$out" = "OK" ] && exit 0
exit 1
