cd "$(dirname "$0")"
d=$(mktemp -d)
printf '{%%%%M.foo| <hello> |}\n' > $d/a.ml
out=$("$1/bin/ocamlc" -c $d/a.ml 2>&1 | grep -A3 '^File' | sed 's/^File "[^"]*"/File/')
rm -rf $d
echo "$out"
case "$out" in *"characters 3-8"*) exit 0;; *) exit 1;; esac
