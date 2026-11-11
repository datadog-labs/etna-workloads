cd "$(dirname "$0")"
d=$(mktemp -d)
{
echo "module F (X : sig val x : int end) = struct"
echo "  let rec f1 y = if y < 0 then f400 (X.x + y) else y"
i=2; while [ $i -le 400 ]; do echo "  and f$i y = (f$((i-1)) [@inlined never]) y"; i=$((i+1)); done
echo "end"
echo "module M = F (struct let x = 1 end)"
echo "let () = print_int (M.f400 5); print_newline ()"
} > $d/p.ml
if ! "$1/bin/ocamlopt" $d/p.ml -o $d/p.exe >/dev/null 2>&1; then echo "compile failed"; rm -rf $d; exit 1; fi
out=$(timeout 20 $d/p.exe 2>&1); rc=$?
rm -rf $d
if [ $rc -eq 0 ] && [ "$out" = 5 ]; then echo ok; exit 0; fi
echo "bad result"; exit 1
