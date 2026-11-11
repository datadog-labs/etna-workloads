cd "$(dirname "$0")"
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
cp repro.ml "$T"; cd "$T"; echo 'let () = failwith "boom"' > plug.ml
O="$1/bin/ocamlfind"; O="$1/bin/ocamlopt"
"$O" -shared -g plug.ml -o plug.cmxs >/dev/null 2>&1 || { echo build fail; exit 1; }
"$O" -g -I +dynlink dynlink.cmxa repro.ml -o r.exe >/dev/null 2>&1 || { echo build fail; exit 1; }
./r.exe > out.txt 2>&1
if grep -q "dynlink.ml\", line 85," out.txt; then echo "BUG: unexpected backtrace"; exit 1; fi
echo ok
