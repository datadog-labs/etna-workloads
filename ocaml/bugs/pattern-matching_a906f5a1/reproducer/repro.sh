cd "$(dirname "$0")"
d=$(mktemp -d)
cp repro.ml "$d/r.ml"
"$1/bin/ocamlc" -dlambda -c "$d/r.ml" 2>&1 | grep -c Match_failure > "$d/n"
n=$(cat "$d/n"); rm -rf "$d"
if [ "$n" = 0 ]; then echo "no match failure: ok"; exit 0; else echo "spurious match failure"; exit 1; fi
