cd "$(dirname "$0")"
T=$(mktemp -d)
"$1/bin/ocamlopt" -w -a repro.ml -o "$T/r" 2>/dev/null || { echo compile fail; rm -rf "$T"; exit 1; }
out=$(timeout 60 "$T/r" 2>&1); rc=$?
rm -rf "$T"
if [ $rc = 0 ] && [ "$out" = 4000 ]; then echo ok; exit 0; fi
echo "bug: failure"; exit 1
