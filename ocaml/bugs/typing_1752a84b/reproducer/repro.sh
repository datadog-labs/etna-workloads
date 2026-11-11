cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -i repro.ml 2>&1)
echo "$out" | grep -v '^File\|^ *[0-9]* |\|\^'
case "$out" in *'should be an instance of "int"'*|*"should be an instance of int"*) exit 0;; *) exit 1;; esac
