cd "$(dirname "$0")"
d=$(mktemp -d); trap 'rm -rf "$d"' EXIT
cp repro.ml "$d/"
echo 'let x : int = true' > "$d/foo.ml"
(cd "$d" && "$1/bin/ocaml" -I +compiler-libs ocamlcommon.cma repro.ml) || { echo setup failed; exit 1; }
out=$(cd "$d" && "$1/bin/ocamlc" -c foo.marshalled.ml 2>&1)
case "$out" in
*"^^^^"*) echo "source quoted"; exit 0;;
*) echo "source not quoted"; exit 1;;
esac
