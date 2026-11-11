# Rationale
Hunk: ocaml/typing/typedecl.ml, `transl_with_constraint`: the call
`Typedecl_variance.compute_decl env ~check:(Some id) new_sig_decl required` became `~check:None`.
Reverses fix.diff hunk `@@ -1451,7 +1451,7 @@ let transl_with_constraint ...`
(`compute_variance_decl env false decl` -> `true`; the boolean was the "check" flag, now `~check`). With no check, the declared variance annotations in a `with type` constraint are not verified.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> build ok;
typing-signatures/pr6672.ml fails (both runs), expected error missing.
