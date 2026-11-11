cd "$(dirname "$0")"
d=$(mktemp -d)
"$1/bin/ocamlc" -c -o "$d/x" repro.ml >"$d/out" 2>&1
sed 's/^File.*//' "$d/out" | grep -v '^ *[0-9]* |' | grep -v '^ *\^' | grep -v '^$'
grep -q "expansion" "$d/out"; r=$?
rm -rf "$d"
exit $((r==0?0:1))
