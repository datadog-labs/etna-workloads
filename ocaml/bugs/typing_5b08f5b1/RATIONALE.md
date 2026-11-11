# Rationale

One hunk, `ocaml/typing/ctype.ml`, in `unify3`: removed the `(Tfield _, Tfield _) -> unify_fields` case
("special case for GADTs") placed before the generic `| _ ->` branch, and put it back in the later
`match (d1, d2)` after `Tvariant`, where the old code had it ("Actually unused").
This reverses the fix hunk `@@ -2133,6 +2133,8 @@ and unify3 env t1 t1' t2 t2' =` (and its companion removal at `@@ -2196,8 +2198,6 @@`).
In pattern (GADT) mode, Tfield/Tfield pairs now go through add_type_equality/link instead of unify_fields, so
the typing-gadts test (PR#5425/5427 cases) no longer finishes (hangs until the 300s timeout, then killed).

Other fix hunks (expand_head_trace in filter_*, printtyp explanation changes) were not reverted: today's code is restructured and reverting them did not change test results.

Commands: `make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
Result: tests/typing-gadts/test.ml => failed (timeout, signal 9).
