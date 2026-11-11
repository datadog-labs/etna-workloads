# Rationale
Hunk 1: ocaml/typing/typecore.ml (`solve_Ppat_construct`): removed
`if constr.cstr_existentials <> [] then lower_variables_only !!penv penv.Pattern_env.equations_scope ty_res;`
and renamed the now-unused `ty_res` binding to `_ty_res` (to avoid the unused-variable warning-as-error).
Reverses fix.diff hunk `@@ -716,11 +716,14 @@ let solve_Ppat_construct ...` in typing/typecore.ml (the added lower_variables_only call).
The `ctype.ml`/`ctype.mli` helper is left defined (it is exported, so no warning); the other fix hunks are
Changes/tests, and the principal-warning tweak was refactored upstream (`penv.in_counterexample` already) and left alone.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
pr10189.ml passed; pr10907.ml failed (unsound_cast is accepted: `val unsound_cast : 'a -> 'b`).

RESULT: injected
