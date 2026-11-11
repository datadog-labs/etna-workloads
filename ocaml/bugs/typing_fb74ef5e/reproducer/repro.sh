cd "$(dirname "$0")"
d=$(mktemp -d)
cat > $d/a.ml <<'EOF'
module type S = sig module M : sig type t val x : t end end
module H = struct type t = A let x = A end
module H' = H
module type S' = S with module M = H'
EOF
out=$("$1/bin/ocamlc" -i $d/a.ml 2>&1 | tail -1)
rm -rf $d
echo "$out"
case "$out" in *"M = H'"*) exit 1;; esac
exit 0
