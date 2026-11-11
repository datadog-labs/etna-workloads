cd "$(dirname "$0")"
D=$(mktemp -d)
cp repro.ml "$D/"
if (cd "$D" && "$1/bin/ocamlc" -c repro.ml >/dev/null 2>&1); then
  echo "compiled ok"; rm -rf "$D"; exit 0
else
  echo "compile error"; rm -rf "$D"; exit 1
fi
