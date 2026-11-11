cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlfind" >/dev/null 2>&1
out=$("$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma repro.ml -o "$d/r" 2>&1 && "$d/r" 2>&1)
rm -rf "$d"
echo "$out"
case "$out" in *"'a"*) exit 1;; esac
exit 0
