cd "$(dirname "$0")"
cat > "${TMPDIR:-/tmp}/r$$.ml" <<'F'
let () = Array.iter (Printf.printf "%d ") (Array.of_seq (List.to_seq [1;2;3]))
F
out=$("$1/bin/ocaml" "${TMPDIR:-/tmp}/r$$.ml"); rm -f "${TMPDIR:-/tmp}/r$$.ml"
echo "$out"
[ "$out" = "1 2 3 " ]
