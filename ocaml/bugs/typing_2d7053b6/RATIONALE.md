# Rationale
Hunk: ocaml/typing/ctype.ml, `occur_rec`: `try_expand_head try_expand_safe env ty` -> `try_expand_head try_expand_once env ty`.
Reverses fix.diff hunk `@@ -1841,7 +1841,7 @@ let rec occur_rec env allow_recursive visited ty0 ty =` (today's code has a different signature/line).
Test/Changes hunks not touched (tests are off-limits).
Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), `sh run-oracle.sh` -> tests/typing-misc/occur_check.ml fails (uncaught Ctype.Escape).
