# Rationale

One hunk, `ocaml/typing/typecore.ml` (Pexp_record case, choice of `ty_record`/`expected_type`).

Reverses fix.diff hunk `@@ -2836,23 +2836,26 @@ and type_expect_` of typing/typecore.ml.
The fix made a non-principal expected record type (`Some (_, _, false)`) fall back to
the type of the `{ e with ... }` expression. In today's code that is the match
`(None | Some (_, _, false)), Some (_, p', _)`. I re-added the old behaviour, where a
non-principal expected type is used as-is (so warning 18 is emitted under -principal).
It is restricted to the case where the expected path is not an alias (`Path.same p0 p`)
and the `with` expression is a plain identifier. Without those restrictions the
compiler's own sources (typing/typemod.ml, lambda/tmc.ml, built with -principal and
warnings as errors) no longer compile.

The fix's Changes and test hunks are not reproduced (test files must not be edited).

Commands: `cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
Result: build succeeds; records.ml fails (extra "Warning 18 [not-principal]" in the
-principal expect run for `let h (x : M.t) = {x with y='a'} :: {x with y='b'} :: []`).
