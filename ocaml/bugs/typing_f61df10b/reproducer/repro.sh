cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1 | grep -v '^ *[0-9]* |' | grep -E 'Error|matches|expected|escape|\$')
echo "$out"
case "$out" in *"($'a S.s, $'a S.s) eq"*) exit 0;; esac
exit 1
