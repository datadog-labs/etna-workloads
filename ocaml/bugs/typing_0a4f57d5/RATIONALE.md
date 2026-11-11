# Rationale
File: ocaml/typing/typetexp.ml
Reverses hunk `@@ -344,12 +344,12 @@ let widen (gl, tv)` of fix.diff (strict_lowercase -> strict_ident):
1. `strict_ident` restored to `strict_lowercase` (only '_' and a-z accepted), and its use in `validate_name`.
2. In `transl_type_aux` (Ptyp_var case), `TyVarEnv.new_var ~name policy` became
   `TyVarEnv.new_var ?name:(validate_name (Some name)) policy`, because in today's code that path bypasses
   the validating wrappers, so without it the bug (capitalised variable names dropped) is not observable.
Result: 'Id_arg prints as 'a, and the error for `'A_name` shows `'a`. Test typing-misc/printing.ml fails.
Commands: make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh -> printing.ml failed.
