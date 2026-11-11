cd "$(dirname "$0")"
T=$(mktemp -d)
cp repro.ml $T/
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlc" -I +compiler-libs ocamlcommon.cma $T/repro.ml -o $T/r 2>/dev/null || { rm -rf $T; echo compile fail; exit 2; }
out=$(timeout 10 $T/r 2>&1); rc=$?
rm -rf $T
if [ $rc = 0 ]; then echo "ok: $out"; exit 0; fi
echo "bug: failed or hung"; exit 1
