cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -c -o /dev/null repro.ml 2>&1 | grep -A0 -E '^File')
echo "$out" | sed 's/^File "[^"]*"/File/'
case "$out" in *"characters 13-14"*) exit 0;; esac
exit 1
