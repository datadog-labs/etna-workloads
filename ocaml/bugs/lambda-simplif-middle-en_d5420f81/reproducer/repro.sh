cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" repro.ml -o "$d/a.out" 2>&1 || { rm -rf "$d"; exit 1; }
"$1/bin/ocamlrun" "$d/a.out" >/dev/null 2>&1
out=$("$1/bin/ocamlc" -version >/dev/null 2>&1; "$d/a.out")
rm -rf "$d"
echo "$out"
[ "$out" = "collected
ok" ]
