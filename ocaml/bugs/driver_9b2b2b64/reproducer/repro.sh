#!/bin/sh
d=$(mktemp -d)
cd "$d"
echo x > unknown-file
"$1/bin/ocamlc" unknown-file >out 2>&1
st=$?
if [ $st -eq 2 ] && grep -q "^Don't know what to do" out && ! grep -q "Fatal error" out; then
  echo ok; r=0
else
  echo "bug: status $st"; r=1
fi
cd /; rm -rf "$d"; exit $r
