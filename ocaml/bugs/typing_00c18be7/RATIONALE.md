# Rationale
Hunk: ocaml/typing/ctype.ml, `extract_concrete_typedecl`: `try_expand_safe env ty` -> `try_expand_once env ty`.
Reverses fix.diff hunk `@@ -1593,7 +1596,7 @@ let rec extract_concrete_typedecl env ty` (typing/ctype.ml). Unify can escape on recursive types (MPR#7937).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/typing-misc/pr7937.ml fails.
