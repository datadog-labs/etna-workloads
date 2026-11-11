cd "$(dirname "$0")"
D=$(mktemp -d)
trap 'rm -rf "$D"' EXIT
: > "$D/fortuna.ml"
echo 'module F = Fortuna' > "$D/rng.ml"
printf 'module Rng : sig\n  module F : sig end\nend\n' > "$D/nocrypto.mli"
cd "$D"
O="$1/bin/ocamlopt"
"$O" -c nocrypto.mli && "$O" -for-pack Nocrypto -c fortuna.ml && "$O" -for-pack Nocrypto -c rng.ml || { echo setup failed; exit 1; }
if "$O" -pack -o nocrypto.cmx fortuna.cmx rng.cmx >/dev/null 2>&1; then echo "pack ok"; else echo "pack failed"; exit 1; fi
