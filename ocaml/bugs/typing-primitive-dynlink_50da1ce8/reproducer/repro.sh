#!/bin/sh
# Native dynlink (PR9209): lib.cmxs declares an external whose C stub is in
# libtest.so; lib2.cmxs calls Lib.test. Loading both must succeed (buggy
# compiler: "undefined symbol: testdynfail").
P="$1"
cd "$(dirname "$0")" || exit 2
SRC=$PWD
T=$(mktemp -d) || exit 2
trap 'rm -rf "$T"' EXIT
cp "$SRC/repro.c" "$T/test.c"
cd "$T" || exit 2
echo 'external test : unit -> int = "testdynfail"' > lib.ml
echo 'let () = print_int (Lib.test ()); print_newline ()' > lib2.ml
cat > dyn.ml <<'E2'
let () =
  try
    Dynlink.allow_unsafe_modules true;
    Dynlink.loadfile (Dynlink.adapt_filename "lib.cma");
    Dynlink.loadfile (Dynlink.adapt_filename "lib2.cma");
    print_endline "ok"
  with Dynlink.Error _ -> print_endline "dynlink error"
E2
O="$P/bin/ocamlopt"
"$O" -c test.c lib.ml lib2.ml >/dev/null 2>&1 &&
"$P/bin/ocamlmklib" -o test test.o >/dev/null 2>&1 &&
"$O" -shared -cclib -L. -cclib -ltest -o lib.cmxs lib.cmx >/dev/null 2>&1 &&
"$O" -shared -o lib2.cmxs lib2.cmx >/dev/null 2>&1 &&
"$O" -I +dynlink dynlink.cmxa -o main.exe dyn.ml >/dev/null 2>&1 || { echo "build failed"; exit 1; }
out=$(LD_LIBRARY_PATH=.${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH} ./main.exe 2>&1)
echo "$out"
[ "$out" = "42
ok" ] || exit 1
exit 0
