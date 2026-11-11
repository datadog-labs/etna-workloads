cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -principal -w -a -c -o "$d/r.cmo" repro.ml >/dev/null 2>&1; then
  echo ok; rm -rf "$d"; exit 0
else
  echo "type error"; rm -rf "$d"; exit 1
fi
