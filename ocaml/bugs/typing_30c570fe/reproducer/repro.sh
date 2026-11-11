cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
if (cd "$d" && "$1/bin/ocamlc" -c repro.ml >/dev/null 2>&1); then
  echo "accepted invalid program"; rm -rf "$d"; exit 1
fi
rm -rf "$d"
echo "rejected"; exit 0
