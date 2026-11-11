# Rationale

One hunk, in `ocaml/typing/typecore.ml`, function `unify_pat_types_return_equated_pairs`:
`if refine || penv.Pattern_env.in_counterexample` became `if refine`.

The fix (`@@ -292,21 +282,25 @@ let get_gadt_equations_level ()` and the many `unify_pat_types ~refine` hunks in `type_pat_aux`)
made all pattern kinds (tuples, variants, records, arrays, lazy, ...) unify with GADT-aware
`unify_gadt` instead of plain `unify`, not just GADT constructors. In 5.5 that behaviour
survives only through the `in_counterexample` branch used by `check_counter_example_pat`
(the exhaustivity check). Removing it brings back plain unification there, so incomplete
unification makes the exhaustivity check unsound again. This reverses the hunks that
introduced `~refine` for non-constructor patterns, e.g.
`@@ -1311,7 +1307,7 @@ ... unify_pat_types ~refine loc env ty expected_ty` (tuples)
and the variant/record ones.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: robustmatch.ml fails (missing Warning 8 output) and pr9019.ml fails (expect
test segfaults, exit -11, because the unsound match is accepted).
