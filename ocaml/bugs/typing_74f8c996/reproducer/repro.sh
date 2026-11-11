cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -c -w +26 -o "$d/r.cmo" repro.ml 2>&1 | grep -v '^ *$' | sed 's/^File "[^"]*", //')
rm -rf "$d"
echo "$out"
case "$out" in *"characters 28-29"*) exit 0;; esac
exit 1
