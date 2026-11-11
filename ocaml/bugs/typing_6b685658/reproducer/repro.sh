cd "$(dirname "$0")"
d=$(mktemp -d); trap 'rm -rf "$d"' EXIT
echo 'type t = int
let f (x : [> t ]) = x' > "$d/a.ml"
out=$("$1/bin/ocamlc" -c "$d/a.ml" 2>&1 | grep -i 'polymorphic variant')
echo "$out" | sed 's/^ *//'
case "$out" in *"does not expand to"*) exit 0;; *) exit 1;; esac
