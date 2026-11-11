#!/bin/sh
here=$(cd "$(dirname "$0")" && pwd)
d=$(mktemp -d)
cp "$here/repro.ml" "$d/"
cd "$d"
"$1/bin/ocamlc" -dsource -c repro.ml >o 2>&1
s=$(tr -d '\n' < o)
cd /; rm -rf "$d"
case "$s" in
  *AAA*BBB*) echo order ok; exit 0;;
esac
echo order wrong; exit 1
