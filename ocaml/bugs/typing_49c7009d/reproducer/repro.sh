cd "$(dirname "$0")"
d=$(mktemp -d)
if "$1/bin/ocamlc" -o "$d/a" repro.ml >/dev/null 2>&1 && "$d/a" >/dev/null; then :; fi
cat > "$d/b.ml" <<'F'
type 'a t = T : ('a -> 'b) * ('b -> 'a) -> 'a t
let t = T ((fun x -> x), (fun x -> x))
let f x = let T (g, h) = t in h (g x)
let _ = (f : int -> string)
F
if "$1/bin/ocamlc" -c "$d/b.ml" >/dev/null 2>&1; then rm -rf "$d"; echo "BUG: ill-typed accepted"; exit 1; fi
rm -rf "$d"; echo "ok: rejected"; exit 0
