cd "$(dirname "$0")"
out=$("$1/bin/ocamlc" -principal -w +A -c -o /dev/null repro.ml 2>&1)
echo "$out" | grep -c "Warning 18" 
case "$out" in *"Warning 18"*) echo "bug: principality warning"; exit 1;; esac
echo ok
