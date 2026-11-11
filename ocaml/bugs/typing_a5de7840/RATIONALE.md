# Rationale
Single file: ocaml/typing/typecore.ml, `Pexp_struct_item` case of type_expect_ (today's home of `let open`; Pexp_open no longer exists).
Reverses hunk `@@ -3612,9 +3612,13 @@ and type_expect_` (`| Pexp_open (od, e) ->`):
1. In the `before_generalize` hook, `unify_var newenv tv exp.exp_type` (the "force return type to be well-formed in the original env" check) is skipped when the item is `Pstr_open` (unify kept for other items).
2. The result is built with `rue` (unify with expected type) instead of `re`, as before the fix.
Effect: pr10048 now gives the "type constructor t would escape its scope" error instead of typing.
Testsuite hunk of fix.diff not touched.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr10048.ml fails (expected output mismatch).
