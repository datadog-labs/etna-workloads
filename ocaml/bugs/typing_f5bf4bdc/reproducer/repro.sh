cd "$(dirname "$0")"
out=$(timeout 60 "$1/bin/ocaml" -w -a repro.ml 2>&1)
s=$?
if [ $s = 2 ]; then echo "$out"; exit 0; fi
echo "unexpected failure"; exit 1
