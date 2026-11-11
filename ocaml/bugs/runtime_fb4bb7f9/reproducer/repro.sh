cd "$(dirname "$0")"
t=$(mktemp -d)
"$1/bin/ocamlc" repro.ml -o $t/r 2>&1 || { rm -rf $t; echo compile fail; exit 1; }
out=$(timeout 20 $t/r 2>&1); rc=$?
rm -rf $t
echo "$out"
[ $rc = 0 ] && [ "$out" = "true true true" ]
