# Rationale

File: ocaml/typing/out_type.ml, function `tree_of_signature_rec` (the code formerly in printtyp.ml).

Hunk: in `collect_trees_of_rec_group`, `set_printing_env env'` is now skipped when the group is made of
`Sig_type` items (Not_rec Sig_type, or Rec_group starting with Sig_type).
Reverses fix.diff hunk `@@ -1190,20 +1190,22 @@ let rec tree_of_modtype ...` in typing/printtyp.ml. That hunk added
`in_type_group` so the printing env is updated between consecutive type declarations
(`set_printing_env env'`). Without it, a type declaration after another one does not see it in the
printing env, so with -short-paths `type v = A.B.t` prints as `A.B.t` instead of `u`.
Today's code has Signature_group instead of the in_type_group flag, so I expressed it as a match on the group.

The other fix.diff hunk (`hide_rec_items`, `@@ -1161,7 +1161,7 @@`) has no counterpart in today's code (it now uses Rec_group).

Commands: `make clean && make -j8 && make -j8 ocamltest` then `sh run-oracle.sh`.
Result: short-paths.ml => failed (M2 prints `type v = A.B.t` rather than `type v = u`).
