# Rationale
File: ocaml/typing/mtype.ml, function strengthen_lazy_sig'.
Removed the case `SigL_type(id, {type_kind=Type_abstract _}, _, _) :: rem when Btype.is_row_name ...` that skips `#row` types when strengthening. This reverses the fix hunk `@@ -46,6 +46,10 @@ and strengthen_sig env sg p pos =` (which added that case to mtype.ml). Today's code has no Private-check, so the case is removed entirely.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: pr6985_ok.ml fails ("The type a#row is required but not provided").
