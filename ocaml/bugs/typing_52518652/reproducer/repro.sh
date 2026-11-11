cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -w +40 -c repro.ml 2>&1 | grep 'selected from')
rm -f repro.cm*
echo "$out" | sed 's/^Warning 40 [^:]*: //'
case "$out" in *M/2.t*) exit 0;; *) exit 1;; esac
