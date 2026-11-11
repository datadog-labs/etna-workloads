cd "$(dirname "$0")"
d=$(mktemp -d)
echo "class ['a] r = let r : 'a = ref [] in object method get = r end;;" > $d/a.ml
if "$1/bin/ocamlc" -c -o $d/a $d/a.ml >/dev/null 2>&1; then echo "accepted unsound class"; rm -rf $d; exit 1; fi
echo "rejected"; rm -rf $d
