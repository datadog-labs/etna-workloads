# Rationale
One hunk, in ocaml/typing/typeclass.ml (class_infos), reversing fix.diff hunk
`@@ -1580,20 +1579,14 @@ let class_infos define_class kind`, second part: the `Abbrev_type_clash` raise.
The fix replaced the dummy `Tobject` constructed from `ty_id`/`params` with
`Ctype.object_fields ty` as the expansion. I restored the old code (dummy object type
`constr` and `ty` as the actual type). The error then reports "#c expands to type #c"
instead of the real expansion.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` followed by a final
`make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`.
Result: Tests.ml passed, pr11569.ml failed.
