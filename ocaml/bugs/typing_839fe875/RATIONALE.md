# Rationale
File typing/typecore.ml, record `{e with ...}` typing (Pexp_record, `exception Not_found` branch):
replaced `unify_exp_types loc env` by `unify env` in both unifications (ty_arg1/ty_arg2 and ty_expected/ty_res2).
Reverses fix.diff hunk `@@ -3069,9 +3069,9 @@ and type_expect_` in typing/typecore.ml. Unify errors are no longer converted to type errors, so Ctype.Unify escapes (MPR#7695).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-misc/records.ml fails.
