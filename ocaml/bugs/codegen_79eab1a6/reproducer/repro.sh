cd "$(dirname "$0")"
t=$(mktemp -d)
"$1/bin/ocamlopt" repro.ml -o $t/r 2>/dev/null || { echo compile fail; rm -rf $t; exit 1; }
out=$(timeout 10 $t/r 2>&1); rc=$?
rm -rf $t
echo "$out"
[ $rc -eq 0 ] && [ "$out" = "-4611686018427387904 0
-9223372036854775808 0" ] && exit 0
echo bug; exit 1
