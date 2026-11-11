cd "$(dirname "$0")"
d=$(mktemp -d); trap 'rm -rf "$d"' EXIT
cp original.ml "$d"
cat > "$d/middle.ml" <<'F'
type 'a ti = 'a Original.t
type (_, _) gadt = G : ('a, 'a ti) gadt
F
cat > "$d/user.ml" <<'F'
let f : type a b. (a Middle.ti -> unit) -> (a,b) Middle.gadt -> b -> unit =
  fun call Middle.G x -> call x
F
cd "$d"
"$1/bin/ocamlc" -c original.ml && "$1/bin/ocamlc" -c middle.ml && rm original.cmi || exit 2
if "$1/bin/ocamlc" -c user.ml >out 2>&1; then echo ok; else echo FAIL; exit 1; fi
