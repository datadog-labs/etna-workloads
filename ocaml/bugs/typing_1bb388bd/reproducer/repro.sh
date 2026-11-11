cd "$(dirname "$0")"
t=$(mktemp -d)
cp repro.ml "$t/m.ml"
cat >> "$t/m.ml" <<'X'
let () = r := Some (`A "x")
let () = match !r with Some (`B n) -> print_int (n+1) | _ -> ()
X
if "$1/bin/ocamlc" -w -a -c "$t/m.ml" >/dev/null 2>&1; then echo "accepted unsound"; rm -rf "$t"; exit 1; fi
echo "rejected"; rm -rf "$t"
