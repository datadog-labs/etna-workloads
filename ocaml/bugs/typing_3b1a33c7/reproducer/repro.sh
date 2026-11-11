cd "$(dirname "$0")"
d=$(mktemp -d)
echo 'module type S = sig type '"'"'a t end
module type T = S with type -'"'"'a t = '"'"'a list' > $d/a.ml
if "$1/bin/ocamlc" -c $d/a.ml >/dev/null 2>&1; then echo "accepted invalid variance"; rm -rf $d; exit 1; fi
echo "rejected"; rm -rf $d
