cd "$(dirname "$0")"
cat > "${TMPDIR:-/tmp}/r$$.ml" <<'F'
let () = try ignore (Array.sub [||] 0 1); print_string "no exception\n"; exit 1
 with Invalid_argument _ -> print_string "ok\n"
F
timeout 20 "$1/bin/ocaml" "${TMPDIR:-/tmp}/r$$.ml"; r=$?
rm -f "${TMPDIR:-/tmp}/r$$.ml"
[ $r = 0 ] && exit 0; exit 1
