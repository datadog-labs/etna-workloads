#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cat > $d/a.ml <<'F'
class x = object
  val[@foo] virtual x : t
end
F
"$1/bin/ocamlc" -stop-after parsing -dparsetree $d/a.ml 2>&1 | grep -c 'attribute "foo"' > $d/o
n=$(cat $d/o); rm -rf $d
if [ "$n" = 1 ]; then echo "attribute kept"; exit 0; else echo "attribute lost"; exit 1; fi
