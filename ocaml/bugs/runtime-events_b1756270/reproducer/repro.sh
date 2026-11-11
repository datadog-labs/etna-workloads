cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d"
cd "$d"
export OCAML_RUNTIME_EVENTS_PRESERVE=1
"$1/bin/ocamlfind" >/dev/null 2>&1
"$1/bin/ocamlopt" -I +unix -I +runtime_events unix.cmxa runtime_events.cmxa repro.ml -o r >/dev/null 2>&1 || { echo compile-fail; cd /; rm -rf "$d"; exit 1; }
out=$(timeout 20 ./r 2>/dev/null); rc=$?
rm -f *.events
cd /; rm -rf "$d"
if [ $rc = 0 ] && [ "$out" = ok ]; then echo ok; exit 0; fi
echo "bug: crash or failure"; exit 1
