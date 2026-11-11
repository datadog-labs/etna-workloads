# Rationale
One hunk, in `ocaml/typing/out_type.ml`, in the final `tree_of_type_declaration` wrapper.

Before, it called `with_hidden_items [{hide=true; ident}] (...)`. That hides the type in the printing env and also registers it in `Ident_names.with_hidden`, which is used for disambiguation.
Now it only calls `wrap_env (hide [{hide=true; ident}]) (...) ()`, so the disambiguation registration is gone.

This reverses the last hunk of `typing/printtyp.ml` in fix.diff, headed `@@ -2042,4 +2047,7 @@ let tree_of_modtype = ...`. That hunk added `Naming_context.with_hidden id (...)` around `wrap_env (hide [id])`.
The other `printtyp.ml` hunks (`stop_type_group` and the related ones) were refactored away upstream, so I did not revert them.

Commands run:
- `make -j8 && make -j8 ocamltest && sh run-oracle.sh`
- final `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`

Result: `disambiguation.ml` fails (`'a x` is printed as `'a x/2` in the constraint). `unique_names_in_unification.ml` passes.
