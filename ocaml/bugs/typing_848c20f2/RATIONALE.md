# Rationale
File: ocaml/typing/typedecl.ml, `check_well_founded`, `Tconstr` case.
Before: when `to_check p` held, the type arguments were checked (with the parents set) before expanding the abbreviation. After: arguments are checked only when expansion is impossible (`Cannot_expand`), as in the pre-fix code. The fix made mutually recursive types behave as abstract and checked their arguments. This undoes that.
Reverses hunk `@@ -492,9 +492,9 @@ let check_abbrev ...` / `check_well_founded` in typing/typedecl.ml. The ordering of arg check and expansion (`arg_exn` / `to_check p`) is reverted. Today's code is structured differently, so the change is re-expressed.
(`let _ = to_check p in` keeps the parameter used.)
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`. constraints.ml, Tests.ml and poly.ml fail.
