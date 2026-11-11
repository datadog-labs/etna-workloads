cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
(cd "$d" && "$1/bin/ocamlc" -c repro.ml 2>&1) | grep -c 't/2' > "$d/n"
n=$(cat "$d/n"); rm -rf "$d"
if [ "$n" -gt 0 ]; then echo "disambiguated names ok"; exit 0; fi
echo "names not disambiguated"; exit 1
