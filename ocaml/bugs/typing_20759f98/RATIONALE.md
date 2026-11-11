# Rationale

One hunk, ocaml/typing/typecore.ml, `type_argument`: the `may_coerce` guard
was `if not (is_inferred sarg) then None else ...`. It is now `eligible`, which is
`is_inferred sarg` or a `let` expression or a function whose first parameter is optional.

Reverses fix.diff hunk `@@ -2322,11 +2322,14 @@ and type_argument env sarg ty_expected' ty_expected =`.
That hunk restricted optional-parameter elimination through coercions to
variables and applications (`is_inferred`). Before the fix, other expressions
(e.g. `let () = () in fun x -> ...`) were also eligible, and the expected
type was not propagated. In today's code `is_inferred` is the equivalent
restriction, so I widen it to non-function expressions that the old code accepted
(`let`) plus optional-argument functions. A fully general widening (all non-function
expressions) broke the compiler's own sources, so I kept it narrow.

The other fix.diff hunks only touch tests, formatting and a comment, so I did not revert them.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: typing-gadts/test.ml fails (the `let () = () in fun x -> match x with Int y -> y`
case gives "int ty -> int but expected a ty -> a"). typing-poly/poly.ml passes.
