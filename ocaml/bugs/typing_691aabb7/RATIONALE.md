# Rationale
One hunk, ocaml/typing/typeclass.ml (class_expr, Pcl_fun case): the class-argument pattern exhaustiveness check
now calls `Parmatch.check_partial (fun _ -> None) ...` over `List.map Parmatch.typed_case [...]` instead of the
GADT-aware `Typecore.check_partial val_env pat.pat_type ...`. Counter-examples are never type-checked, so none is reported.
Reverses the fix.diff hunk `@@ -957,7 +957,7 @@ and class_expr cl_num val_env met_env scl =` in typing/typeclass.ml
(`Parmatch.check_partial pat.pat_loc` -> `Typecore.check_partial val_env pat.pat_type pat.pat_loc`).
The other fix hunks (unify_head_only swap, PR6849) have no observable effect in today's code, so were not reverted.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: tests/typing-gadts/test.ml fails (missing PR6862 partial-match warnings).
