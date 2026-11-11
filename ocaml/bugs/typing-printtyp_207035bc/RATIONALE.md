# Rationale
One hunk, `typing/out_type.ml`, `Ident_names.with_hidden`: only the last identifier of a recursive group is recorded in `bound_in_recursion`. Previously all were recorded.
This reverses the fix.diff hunk `@@ -262,10 +262,9 @@ let with_arg id f =` (printtyp.ml, `with_hidden ids f`), which changed it from remembering one item to remembering all recursive items. The PR#8917 test is the target. The rest of the fix has already been restructured upstream.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`. broken_rec_in_show.ml and merge_constraint.ml fail.
Final: `make clean && make -j8 && make -j8 ocamltest` (succeeded), then run-oracle.sh still showed failures.
