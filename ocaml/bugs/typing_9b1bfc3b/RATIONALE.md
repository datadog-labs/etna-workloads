# Rationale
File: ocaml/typing/typedecl.ml, in `transl_with_constraint`: removed the computation of `new_type_separability` (Typedecl_separability.compute_decl) and the final record now copies `new_sig_decl.type_separability` (the default signature). This reverses fix.diff hunk `@@ -1448,7 +1448,16 @@ let transl_with_constraint env id row_path orig_decl sdecl =` (today's code builds the record explicitly rather than `{decl with ...}`).
Effect: separability isn't computed for with-constraints, so `type t = T : 'k M.t -> t [@@unboxed]` is rejected (#9607).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-unboxed/test.ml fails; final `make clean && make -j8 && make -j8 ocamltest` then oracle: failures present.
