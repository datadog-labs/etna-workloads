# Rationale
Fix PR#6174 added `wrap_trace_gadt_instances` calls in typing/typecore.ml. In today's code I removed them again:
- ocaml/typing/typecore.ml, `list_labels`: now calls `list_labels_aux env TypeSet.empty [] ty` directly. Reverses hunk `@@ -1703,7 +1703,8 @@ let rec list_labels_aux ...`.
- ocaml/typing/typecore.ml, in type_expect_ application case: `lower_args env TypeSet.empty ty` without the wrapper. Reverses hunk `@@ -2041,7 +2042,7 @@ and type_expect_ ...`.
(The ctype.ml refactor hunks are only a refactor; ctype still has the wrapper, used elsewhere.)

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: pr6174_bad.ml fails (ocamlc loops until killed, exit -9).
