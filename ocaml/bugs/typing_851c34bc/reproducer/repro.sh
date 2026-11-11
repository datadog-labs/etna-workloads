cd "$(dirname "$0")"
d=$(mktemp -d)
timeout 20 "$1/bin/ocamlc" -c -o "$d/r" repro.ml >"$d/o" 2>&1
s=$?
if [ $s -ne 0 ]; then echo "rejected"; rm -rf "$d"; exit 0; fi
echo "accepted invalid program"; rm -rf "$d"; exit 1
