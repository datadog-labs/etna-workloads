cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlopt" -I +runtime_events runtime_events.cmxa repro.ml -o "$d/a" 2>/dev/null || "$1/bin/ocamlopt" -I +runtime_events runtime_events.cmxa repro.ml -o "$d/a" || { rm -rf "$d"; echo compile fail; exit 1; }
OCAMLRUNPARAM=e=8 timeout 10 "$d/a" >"$d/out" 2>&1
rc=$?
rm -rf "$d"
if [ $rc -eq 134 ]; then echo "fatal error as expected"; exit 0; fi
echo "unexpected, no fatal error"; exit 1
