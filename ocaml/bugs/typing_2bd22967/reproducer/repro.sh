cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
if (cd "$d" && "$1/bin/ocamlc" -w -a -c repro.ml >/dev/null 2>&1); then
  echo "bug: invalid program accepted"; rm -rf "$d"; exit 1
fi
rm -rf "$d"; echo "correctly rejected"; exit 0
