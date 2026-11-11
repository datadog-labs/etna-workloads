# Rationale
One hunk, ocaml/typing/ctype.ml, `unify_row_field`, Reither/Reither case: removed the
`if either_fixed && not no_arg && List.length tl1 = List.length tl2 then begin ... end else`
branch (the PR#7496 special case that links both fields to a shared Reither and unifies argument lists).
Reverses fix.diff hunk `@@ -2703,7 +2703,14 @@ and unify_row_field env fixed1 fixed2 more l f1 f2 =`.
(The test/Changes hunks are not implementation.)

Commands: `make clean; make -j8 && make -j8 ocamltest` (clean build; the first invocation timed out, then rebuilt incrementally OK), then `sh run-oracle.sh`: typing-poly/poly.ml fails (diff in the PR#7496 test).
