#!/bin/sh
# Check that compiled .cmt does not depend on unrelated cmis present on disk.
cd "$(dirname "$0")"
P="$1"
D=$(mktemp -d)
trap 'rm -rf "$D"' EXIT
cp repro.ml "$D/repro.ml"
cd "$D"
FL="-bin-annot -no-alias-deps -w -49 -c"
"$P/bin/ocamlc" $FL repro.ml || { echo "compile1 failed"; exit 1; }
mv repro.cmt lone.cmt
echo 'type u' > repro_companion.mli
"$P/bin/ocamlc" -c repro_companion.mli || { echo "companion failed"; exit 1; }
"$P/bin/ocamlc" $FL repro.ml || { echo "compile2 failed"; exit 1; }
if cmp -s repro.cmt lone.cmt; then
  echo "cmt identical: ok"; exit 0
else
  echo "cmt differs: BUG"; exit 1
fi
