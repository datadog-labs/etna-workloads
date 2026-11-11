cd "$(dirname "$0")"
d=$(mktemp -d)
cat > "$d/m.ml" <<'EOT'
type 'a box
external box_make : 'a -> 'a box = "box_make"
external box_deref : 'a box -> 'a = "box_deref"
type chain = Nil | Cons of chain box
let rec make_chain = function 0 -> Nil | n -> Cons (box_make (make_chain (n-1)))
let rec check_chain len = function
  | Nil -> assert (len = 0)
  | Cons ch -> check_chain (len - 1) (box_deref ch)
let () =
  let len = 1000 in
  for _i = 1 to 5 do
    let ch = make_chain len in
    for _j = 1 to 5 do Gc.compact (); check_chain len ch done
  done;
  print_endline "ok"
EOT
cp repro.c "$d/"
(cd "$d" && "$1/bin/ocamlopt" repro.c m.ml -o m.exe >/dev/null 2>&1) || { echo "compile failed"; rm -rf "$d"; exit 1; }
out=$(cd "$d" && timeout 60 ./m.exe 2>/dev/null); rc=$?
rm -rf "$d"
if [ $rc -eq 0 ] && [ "$out" = ok ]; then echo ok; exit 0; fi
echo "bug: failed"; exit 1
