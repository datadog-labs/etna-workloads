cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -principal -i repro.ml -o "$d/x" 2>&1)
rm -rf "$d"
echo "$out"
case "$out" in *weak*) exit 1;; esac
exit 0
