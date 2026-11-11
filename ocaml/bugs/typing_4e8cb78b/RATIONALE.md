# Rationale

Fix reversed: PR#7115 (`@@ -1861,19 +1861,10 @@ let duplicate_ident_types` in typing/typecore.ml, plus
the new `Env.update_value` hunks in typing/env.ml). The fix replaced a lookup that marked
the original value as used (`Env.lookup_value` + `Env.add_value`) with a version that
doesn't mark values used. Today's code has no `duplicate_ident_types`; the equivalent is
`Env.make_copy_of_types` (typing/env.ml), used for GADT match branches.

Hunk changed: typing/env.ml, `make_copy_of_types`: before building the copied table, iterate
over all values in env0 and call their usage-marking callback (`value_declarations`). This
re-creates the old behaviour of "this will mark the value as being used" on entering a GADT match,
so unused variable / value / open warnings (27, 32, 33) are lost (pr7115.ml).

Commands: `make clean && make -j8 && make -j8 ocamltest` then `sh run-oracle.sh`:
pr7115.ml => failed (expected warning 33 on X3 missing).
