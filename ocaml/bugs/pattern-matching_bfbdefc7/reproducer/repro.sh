cd "$(dirname "$0")"
d=$(mktemp -d); cp repro.ml "$d"/user.ml; cd "$d"
cat > original.ml <<'X'
type t = A | B
type r = {x:int}
X
cat > middle.ml <<'X'
type t = Original.t
type r = Original.r = {x:int}
let r : r = Obj.magic 0
X
"$1/bin/ocamlc" -c original.ml && "$1/bin/ocamlc" -c middle.ml || { echo setup fail; exit 2; }
rm -f original.cmi
out=$("$1/bin/ocamlc" -c user.ml 2>&1); rc=$?
cd /; rm -rf "$d"
echo "$out" | grep "example"
[ "$(echo "$out" | grep -c "Some { _ }")" = 1 ] || exit 1
