#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cat > "$d/t.ml" <<'X'
let f x = match x with List.(Some y) -> y | _ -> 0
X
out=$(timeout 10 "$1/bin/ocamlc" -dsource -c "$d/t.ml" 2>&1)
rm -rf "$d"
:
case "$out" in *"List.("*) echo ok; exit 0;; *) echo BUG; exit 1;; esac
