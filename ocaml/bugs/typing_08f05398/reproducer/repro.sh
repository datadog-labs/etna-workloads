d=$(mktemp -d)
echo "type 'a t = 'b constraint 'a = 'b t;;" > "$d/a.ml"
timeout 10 "$1/bin/ocamlc" -c "$d/a.ml" >"$d/out" 2>&1
r=$?
rm -rf "$d"
if [ $r = 2 ]; then echo "rejected as irregular"; exit 0; fi
echo "bug: status $r"; exit 1
