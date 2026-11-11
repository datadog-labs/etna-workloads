# Rationale
Hunk: ocaml/typing/typecore.ml, in the coercion-with-source-type branch of the (:>) typing function (`Some sty ->`).
Changed `subtype env (generic_instance ty) (generic_instance ty')` back to `subtype env ty ty'`.
Reverses fix.diff hunk `@@ -3459,15 +3459,15 @@ and type_expect_`, which made subtype run on instances of the generalized types. Generalization is already done by with_local_level_generalize_structure in today's code, so only the instance part is undone.
Commands: make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh. principality-and-gadts.ml fails (3 "=> failed" lines).
