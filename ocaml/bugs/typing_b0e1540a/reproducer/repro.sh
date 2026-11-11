here=$(cd "$(dirname "$0")" && pwd)
d=$(mktemp -d)
cp "$here/repro.ml" "$d/"
cd "$d"
"$1/bin/ocamlc" -w +A -c repro.ml 2>&1 | grep -c 'unused value' > n
n=$(cat n); cd /; rm -rf "$d"
if [ "$n" -ge 1 ]; then echo "warning emitted"; exit 0; else echo "missing warning 32"; exit 1; fi
