# Rationale
Hunk: ocaml/typing/value_rec_check.ml, `is_valid_class_expr`: the `Tcl_let` case no longer analyses the let bindings (`value_bindings ...`); it just recurses into the body. So recursion through toplevel let-definitions of a class expression goes undetected (`class a = let _ = new a in object end` is accepted, loops at runtime).
Reverses fix.diff hunk `@@ -362,11 +362,15 @@ let rec build_class_lets cl ids` in bytecomp/translclass.ml (the check of recursion in toplevel let-definitions of classes). In today's code the check lives in typing, not translclass, so it is re-expressed there. The other fix hunks (moving the check, error message text) are already equivalent in current code and were not touched.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: tests/typing-objects/Tests.ml fails (expect run dies, exit -11, instead of printing the error).
