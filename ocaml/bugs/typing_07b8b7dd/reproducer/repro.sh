cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -o "$d/a" repro.ml >/dev/null 2>&1 && "$d/a" >/dev/null; then
 echo ok; rm -rf "$d"; exit 0
fi
echo "bug: generalization failed"; rm -rf "$d"; exit 1
