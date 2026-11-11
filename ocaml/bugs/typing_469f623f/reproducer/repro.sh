cd "$(dirname "$0")"
d=$(mktemp -d)
cat > $d/a.ml <<'F'
class virtual v = object method virtual m : int end
class c = v
F
if "$1/bin/ocamlc" -c $d/a.ml >/dev/null 2>&1; then echo "accepted invalid program"; rm -rf $d; exit 1; fi
echo "rejected"; rm -rf $d
