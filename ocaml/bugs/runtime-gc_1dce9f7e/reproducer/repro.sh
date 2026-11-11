cd "$(dirname "$0")"
d=$(mktemp -d)
cp stub.c "$d"
cat > "$d/main.ml" <<'EOM'
external run : unit -> int = "run"
let () = if run () = 0 then print_endline "ok" else (print_endline "space leak"; exit 1)
EOM
(cd "$d" && "$1/bin/ocamlopt" -I "$1/lib/ocaml" stub.c main.ml -o r >/dev/null 2>&1) || { rm -rf "$d"; echo "build failed"; exit 1; }
timeout 60 "$d/r"; s=$?
rm -rf "$d"
[ $s -eq 0 ] && exit 0
exit 1
