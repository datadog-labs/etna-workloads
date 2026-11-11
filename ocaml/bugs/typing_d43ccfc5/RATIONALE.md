# Rationale

One hunk, in `ocaml/typing/typecore.ml` (`map_half_typed_cases`):
removed the call `check_scope_escape htc.typed_pat.pat_loc env outer_level htc.pat_type_for_unif;`
(and the now-unused `let outer_level = get_current_level () in`).

It reverses the fix.diff hunk `@@ -4712,6 +4718,8 @@ and type_cases ...`, which added the late check
"Ensure that no ambivalent pattern type escapes its branch" (`unify_pat_types loc env ty_arg' (newvar ())`).
In today's code that late check is expressed as `check_scope_escape` on the pattern's type. Without it,
ambiguous type escapes are no longer reported.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final
`make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`.
Result: ambiguity.ml and pr7618.ml fail, and polyvars.ml passes.
