# Rationale
Hunk: ocaml/typing/typecore.ml, in type_cases: `check_partial ~lev env ty_arg_check loc val_cases` changed to use `ty_arg'` (the uncopied type), reversing the fix hunk `@@ -3903,25 +3903,28 @@ and type_cases ...` which made check_partial use the copied ty_arg_check (so existential variables aren't unified during the exhaustiveness check). The today's code already computes ty_arg_check before; only the check_partial use was reverted.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/typing-gadts/pr7390.ml fails (warning output differs).
