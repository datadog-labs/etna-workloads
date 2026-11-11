# Rationale
File: ocaml/typing/typedecl.ml, function `transl_with_constraint`, two one-word changes:
- `Typedecl_variance.compute_decl env ...` -> `compute_decl outer_env ...`
- `Typedecl_separability.compute_decl env ...` -> `compute_decl outer_env ...`

Reverses the fix.diff hunk `@@ -1434,55 +1464,56 @@ ...` in typing/typedecl.ml, where variance and separability
were moved from the (old) single outer env to be computed in `sig_env` (the `let env = sig_env` introduced by
the hunk `@@ -1401,22 +1410,43 @@`). The bug: variance/separability are recomputed in the outer environment, wrong for declarations that live in sig_env (#9624).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-modules/merge_constraint.ml fails (expected output differs).
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: still fails.
