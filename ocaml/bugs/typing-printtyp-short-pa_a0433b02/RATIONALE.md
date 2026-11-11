# Rationale
One hunk, `ocaml/typing/out_type.ml`, in `tree_of_signature_rec` (`collect_trees_of_rec_group`).
The printing env is now advanced (`set_printing_env env'`) only when the group is not a type declaration group.
This reverses the fix hunk `@@ -1171,15 +1171,17 @@ let rec tree_of_modtype` in typing/printtyp.ml. That hunk added `in_type_group` tracking and a `set_printing_env env'` call for each type item in a sequence. The old code skipped the env update for type items, so `type u = A.B.t type foo = int type v = A.B.t` printed `v = A.B.t` instead of `v = u`.
The other printtyp hunk (`rs = Trec_first` in hide_rec_items) has no equivalent in the current code, because Signature_group replaced it.

Commands run: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: short-paths.ml fails, in both the compiler and toplevel variants.
