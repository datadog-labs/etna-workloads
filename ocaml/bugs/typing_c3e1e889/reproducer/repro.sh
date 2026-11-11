#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cat > "$d/a.ml" <<'F'
module type S1 = sig end
module type S2 = functor (X : S1) -> sig module M = X end
F
if "$1/bin/ocamlc" -c "$d/a.ml" >/dev/null 2>&1; then
  echo "invalid alias accepted"; rm -rf "$d"; exit 1
fi
echo "rejected"; rm -rf "$d"; exit 0
