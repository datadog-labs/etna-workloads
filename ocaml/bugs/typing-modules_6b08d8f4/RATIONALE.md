# Rationale
All edits in ocaml/typing/typemod.ml.

1. `approx_modtype`, `Pmty_with` case: restored the old behaviour (approximate the body only, ignore constraints except the lookup of `with module` paths for cyclicity) instead of extracting the signature and merging approximated constraints. Reverses hunk `@@ -804,24 +877,26 @@ let rec approx_modtype env smty =`.
2. Removed `approx_constraint` (added by `@@ -943,7 +1018,30 @@ and approx_modtype_info env sinfo =`), which is now unused.
3. Removed `merge_type_approx` (today's equivalent of the fix's `merge_constraint_approx` hunk `@@ -730,6 +791,18 @@ let () =`); it would otherwise be an unused-value error.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: module_type_substitution.ml fails (approximation tests); recursive.ml passes.
