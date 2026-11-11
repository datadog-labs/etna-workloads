# Rationale
Hunk: ocaml/typing/typecore.ml, `type_label_a_list`: removed the `List.sort` by `lbl_pos` of the
typed label list (and its invariant comment). This reverses the fix.diff hunks that make
records sorted in the typed tree (`@@ -405,21 +405,39 @@ let build_or_pat ...` in typing/typecore.ml,
which added sorting in type_label_a_list; the Parmatch `sort_fields`/`sort_record` removal hunks
(`@@ -51,16 +51,19 @@`, etc.) relied on this invariant, and parmatch today already assumes sorted input).
Without sorting, parmatch's records_args/lub assume sorted fields and mis-handle out-of-order record patterns.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-gadts/test.ml failed.
