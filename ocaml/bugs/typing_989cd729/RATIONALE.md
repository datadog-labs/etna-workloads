# Rationale
Hunk: ocaml/typing/includecore.ml, constructor-argument comparison (Cstr_tuple case in compare_constructor_arguments).
Reverses fix.diff hunk `@@ -171,9 +171,9 @@ let rec compare_constructor_arguments ...`: instead of a single
Ctype.equal over params1@arg1 vs params2@arg2, each argument is compared separately with (ty::params), so type variables
are not consistently matched across arguments (PR#7378: X.A ('a*'b*('a->unit)) accepted as X.A ('a*'b*('b->unit))).
The second fix hunk (compare_records accumulating params) has no counterpart in today's code (already restructured), so not touched.
Commands: make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh -> pr7378.ml fails.
