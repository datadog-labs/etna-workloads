cd "$(dirname "$0")"
d=$(mktemp -d)
out=$("$1/bin/ocamlc" -w +8 -o "$d/r" repro.ml 2>&1)
rm -rf "$d"; rm -f repro.cm*
echo "$out"
case "$out" in *AnyOtherTag*) exit 1;; esac
exit 0
