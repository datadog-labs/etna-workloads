cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
if (cd "$d" && "$1/bin/ocamlc" -c repro.ml >/dev/null 2>&1); then
  rm -rf "$d"; echo "accepted invalid let rec"; exit 1
fi
rm -rf "$d"
echo "rejected as expected"
