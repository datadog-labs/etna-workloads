cd "$(dirname "$0")"
T=$(mktemp -d)
cp repro.ml $T/
"$1/bin/ocamlfind" 2>/dev/null
"$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma $T/repro.ml -o $T/r 2>&1 || { rm -rf $T; echo compile fail; exit 1; }
"$T/r" > $T/out; rm -f $T/r
cat $T/out
if [ "$(cat $T/out)" = "$(printf 'let _ = (~$ x).contents\nlet _ = r.f <- (fun x -> x)\nlet _ = r.f <- (a := b)')" ]; then rm -rf $T; exit 0; fi
rm -rf $T; exit 1
