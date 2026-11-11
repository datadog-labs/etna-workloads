#!/bin/sh
# Check that the .cmt produced with -no-alias-deps does not depend on
# whether the aliased module's .cmi exists on the file system.
cd "$(dirname "$0")"
OCAMLC="$1/bin/ocamlc"
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
cp repro.ml "$T/repro.ml"
echo 'type u' > "$T/repro_companion.mli"
cd "$T"
FLAGS="-bin-annot -no-alias-deps -w -49 -c"
"$OCAMLC" $FLAGS repro.ml || { echo "compile 1 failed"; exit 1; }
mv repro.cmt lone.cmt
"$OCAMLC" -c repro_companion.mli || { echo "compile companion failed"; exit 1; }
"$OCAMLC" $FLAGS repro.ml || { echo "compile 2 failed"; exit 1; }
if cmp -s repro.cmt lone.cmt; then
  echo "cmt identical: ok"; exit 0
else
  echo "cmt differs depending on cmis on file system: BUG"; exit 1
fi
