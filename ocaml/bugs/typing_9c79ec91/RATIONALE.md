# Rationale

One hunk, ocaml/typing/ctype.ml, in `unify_row_field`: removed the block
`(* Is this handling of levels really principal? *) let update_levels rm = ... in update_levels rm2 tl1'; update_levels rm1 tl2';`
This reverses the fix.diff hunk `@@ -1847,13 +1847,15 @@ and unify_row_field ...` which added
`List.iter (update_level env (repr more).level) (tl1' @ tl2');`. Levels of row-field
argument types are no longer adjusted to the row's level (PR#5057). The `more` parameter
threading in the other hunks is not needed in today's code (rm1/rm2 are already passed).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final
`make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: pr5057a_bad.ml fails (it should be rejected with an error but is now accepted); other tests pass.
