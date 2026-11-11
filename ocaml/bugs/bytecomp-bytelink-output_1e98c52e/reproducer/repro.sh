cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -w -a -output-complete-exe repro.ml -o "$d/t" >/dev/null 2>&1 || { echo "build failed"; rm -rf "$d"; exit 1; }
out=$("$d/t" 2>&1)
rm -rf "$d"
if [ "$out" = "Hello
Program terminated" ]; then echo "ok"; else echo "at_exit not run"; exit 1; fi
