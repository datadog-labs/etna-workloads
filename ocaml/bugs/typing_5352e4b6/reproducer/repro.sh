cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
if (cd "$d" && "$1/bin/ocamlc" -w -a -c repro.ml >/dev/null 2>&1); then
  rm -rf "$d"; echo "accepted invalid program"; exit 1
fi
rm -rf "$d"; echo "rejected"; exit 0
