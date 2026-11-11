cd "$(dirname "$0")"
out=$(timeout 20 "$1/bin/ocamlc" -c repro.ml 2>&1)
r=$?
rm -f repro.cm* 
if [ $r = 2 ] && ! echo "$out" | grep -qi "overflow"; then echo "correct: rejected"; exit 0; fi
echo "bug: status $r"; exit 1
