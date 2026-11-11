cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml $d/
if (cd $d && "$1/bin/ocamlfind" 2>/dev/null; "$1/bin/ocamlc" -I +runtime_events runtime_events.cma repro.ml -o r >/dev/null 2>&1) && (cd $d && ./r) ; then rc=0; else echo "BUG: constructor missing"; rc=1; fi
rm -rf $d
exit $rc
