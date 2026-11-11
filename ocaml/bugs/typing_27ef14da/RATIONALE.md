# Rationale
One hunk, ocaml/typing/typecore.ml, `unify_pat_types_return_equated_pairs`: changed
`if refine || penv.Pattern_env.in_counterexample then unify_gadt ...` to `if refine then unify_gadt ...`.
Reverses fix.diff hunk `@@ -298,21 +288,25 @@ let get_gadt_equations_level ()` (typing/typecore.ml), which made
`unify_pat_types` use GADT unification (`refine`) in Counter_example mode for all patterns, not just GADT
constructors. Today's code expresses that as the `in_counterexample` disjunct; removing it restores the bug
(incomplete unification in exhaustivity counter-example checking -> unsound GADT exhaustivity).
Commands: `cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`.
Result: robustmatch.ml and pr9019.ml both fail (pr9019 expect crashes with -11; robustmatch output differs from reference).
