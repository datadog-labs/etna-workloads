# Rationale
Hunks (reverse of fix.diff):
1. ocaml/parsing/pprintast.ml, core_type1 `Ptyp_variant`: removed `first_is_inherit` binding and made `(Closed,None)` print "" again. Reverses hunks `@@ -330,6 +330,9 @@ and core_type1` and `@@ -348,7 +351,7 @@`. `[ | u ]` is printed as `[ u ]`, which is a different type when reparsed.
2. ocaml/parsing/parsetree.mli: comment of `Rinherit` back to `[[ t ]]` (reverses `@@ -174,7 +174,7 @@ and row_field_desc`).
Changes and test hunks not touched (tests are off-limits).
Ran: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: parsetree/test.ml fails (byte and native); locations_test.ml passes.
