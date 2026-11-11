cd "$(dirname "$0")"
out=$(timeout 60 "$1/bin/ocamlnat" -noinit -no-version -noprompt < in.ml 2>&1)
rc=$?
case "$out" in *done*) [ $rc -eq 0 ] && { echo "ok"; exit 0; };; esac
echo "bug: native toplevel failed"; exit 1
