cd "$(dirname "$0")"
d=$(mktemp -d); cp repro.ml $d/; out=$(cd $d; timeout 60 "$1/bin/ocamlc" -c repro.ml 2>&1); rm -rf $d
case "$out" in *"does not allow"*) echo "correct error"; exit 0;; *) echo "wrong: $out" | head -5; exit 1;; esac
