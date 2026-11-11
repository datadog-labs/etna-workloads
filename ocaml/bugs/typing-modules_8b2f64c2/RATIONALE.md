# Rationale
File: ocaml/typing/typemod.ml, `merge_type`'s `patch` function (two hunks).
Fix hunk reversed: `@@ -459,10 +459,11 @@ let merge_constraint ...` / the `~sig_env:env` hunks. The fix made the
signature environment contain the whole signature (`Env.add_signature sg ...`).
In today's code that is `let sig_env = Env.add_signature sg_for_env sig_env in`
in both type-constraint branches (fixed-row and ordinary). I removed both lines, so
`transl_with_constraint`/`check_type_decl` again use an env lacking the signature's items.

Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh`.
Result: merge_constraint.ml fails (Not_found / stack overflow in the new regression tests); sigsubst.ml passes.
