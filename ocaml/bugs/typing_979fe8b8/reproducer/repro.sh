cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/"
if (cd "$d" && "$1/bin/ocamlc" -c repro.ml) >"$d/out" 2>&1; then
  echo "compiled ok"; rm -rf "$d"; exit 0
else
  echo "compile failed"; rm -rf "$d"; exit 1
fi
