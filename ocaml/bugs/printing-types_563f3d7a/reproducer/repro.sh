#!/bin/sh
cd "$(dirname "$0")"
d=$(mktemp -d)
cat > $d/r.ml <<'X'
let f y = fun x -> x
let blah = f 0
let splash () = blah (failwith "coucou")
let blurp = f 0;;
X
out=$("$1/bin/ocaml" -noprompt < $d/r.ml 2>&1 | grep -E 'splash|blurp')
rm -rf $d
echo "$out"
case "$out" in *"splash : unit -> '_weak1"*) exit 0;; *) exit 1;; esac
