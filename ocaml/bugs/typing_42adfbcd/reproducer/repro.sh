cd "$(dirname "$0")"
d=$(mktemp -d)
cat > "$d/r.ml" <<'EOF'
module type S = sig type 'a t = [ `A of 'a ] val x : 'a t -> [< 'a t] end
module type S1 = S with type 'a t := [ `A of 'a ]
EOF
out=$("$1/bin/ocamlc" -i "$d/r.ml" 2>&1); rc=$?
rm -rf "$d"
echo "$out"
[ $rc -eq 0 ] || exit 1
