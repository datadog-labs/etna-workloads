# Rationale
Hunk: ocaml/typing/typemod.ml, `patch_deep_item` (deep `Sig_module` case): the recursive call
`merge_signature ~patch initial_env sig_env sg ...` now passes `env` instead of `sig_env`, so the
nested signature/outer items are no longer added to the environment used for deeper constraints.
Reverses fix.diff hunks `@@ -559,16 +559,18 @@ let merge_constraint` (and related `merge sig_env ...` threading hunks):
the fix threaded an environment extended with each inner signature (`Env.add_signature sg sig_env`) into the recursive merge.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
tests/typing-modules/merge_constraint.ml fails (Iobuf_packet expected output differs).
