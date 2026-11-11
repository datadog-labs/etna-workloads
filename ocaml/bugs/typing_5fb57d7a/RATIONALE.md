# Rationale
One hunk in `ocaml/typing/typecore.ml`, in `map_half_typed_cases`: the continuation variable is added to `when_env` together with the pattern variables (`add_pattern_vars ext_env (pvs @ cont_vars)`), and `ext_env = when_env`. Guards are typed in `when_env`, so they can see the continuation `k`.
Today's code separates the two environments: `when_env` has no continuation, and `ext_env` adds it.

This reverses the fix hunks `@@ -5801,23 +5801,13 @@ and map_half_typed_cases` and `@@ -5908,6 +5898,16 @@ and type_cases`. Those hunks moved the continuation binding out of the guard's environment. They are re-expressed here against today's code, where the split is `when_env`/`ext_env`.

Commands run: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: `tests/effect-syntax/when_test.ml` fails. The guard type-checks instead of giving "Unbound value k", and the test raises Continuation_already_resumed.
