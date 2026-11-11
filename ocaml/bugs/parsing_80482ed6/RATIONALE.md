# Rationale
Reverses fix.diff hunks `@@ -208,8 +208,8 @@ let mkexp_constraint` and `@@ -218,7 +218,7 @@ let mkpat_opt_constraint` (type constraints no longer ghost -> ghost again).
- ocaml/parsing/parser.mly: mkexp_constraint uses `ghexp` instead of `mkexp`; mkpat_opt_constraint uses `ghpat` instead of `mkpat`.
- ocaml/boot/menhir/parser.ml: same two edits in the checked-in generated parser.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/parsetree/locations_test.ml fails (locations differ: ghost flag on constraints).
