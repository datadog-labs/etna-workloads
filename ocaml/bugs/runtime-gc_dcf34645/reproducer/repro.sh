set -e
cd "$(dirname "$0")"
d=$(mktemp -d); trap 'rm -rf "$d"' EXIT
cat > "$d/t.ml" <<'M'
external test : int ref -> int = "stub"
let f () =
  let r = ref 42 in
  Gc.finalise (fun s -> r := !s) (ref 17);
  let v = test r in
  Printf.printf "value seen in C: %d\n" v
let () = (f [@inlined never]) ()
M
cp repro.c "$d/"
(cd "$d" && "$1/bin/ocamlfind" >/dev/null 2>&1 || true)
(cd "$d" && "$1/bin/ocamlopt" -o t repro.c t.ml >/dev/null 2>&1) || { echo build failed; exit 1; }
out=$("$d/t")
echo "$out"
[ "$out" = "value seen in C: 42" ]  || exit 1
