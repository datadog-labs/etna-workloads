cd "$(dirname "$0")"
out=$(timeout 10 "$1/bin/ocamlc" -i repro.ml 2>&1 >/dev/null; echo "st=$?")
out=$(timeout 10 "$1/bin/ocamlc" -c -o /dev/null repro.ml 2>&1)
rc=$?
if [ $rc = 124 ] || [ $rc = 137 ] || [ $rc = 134 ] || [ $rc = 139 ] || echo "$out" | grep -qi "overflow"; then echo "BUG: crash/hang"; exit 1; fi
echo "$out" | grep -c "Constructors do not match\|Fields do not match"
exit 0
