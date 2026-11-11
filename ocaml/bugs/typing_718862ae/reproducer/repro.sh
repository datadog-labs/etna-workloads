cd "$(dirname "$0")"
d=$(mktemp -d)
echo "type u = (int -> int as '_a)" > $d/a.ml
if "$1/bin/ocamlc" -c $d/a.ml >/dev/null 2>&1; then echo accepted; rm -rf $d; exit 1; fi
echo rejected; rm -rf $d
