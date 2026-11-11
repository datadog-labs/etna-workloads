cd "$(dirname "$0")"
T=$(mktemp -d)
cp repro.ml $T/
if "$1/bin/ocamlc" -c $T/repro.ml >/dev/null 2>&1; then echo correct; rm -rf $T; exit 0
else echo bug; rm -rf $T; exit 1; fi
