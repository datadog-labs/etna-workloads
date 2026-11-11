# Rationale
Hunk: ocaml/runtime/gc_ctrl.c, caml_gc_set (lines ~186-188). Removed the `Long_val(...)` conversions around
`Field (v, 8)`, `Field (v, 9)`, `Field (v, 10)` for custom_major_ratio / custom_minor_ratio / custom_minor_max_size.
Reverses fix.diff hunk `@@ -475,21 +475,21 @@ CAMLprim value caml_gc_set(value v)` (in today's code these are initializers at the top of the function).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/regression/pr9326/gc_set fails (assertion failed).
Final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh: build ok, failures confirmed (grep count of "=> failed" lines: 5, including gc_set).
