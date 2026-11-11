# Rationale
Hunk: ocaml/runtime/obj.c, caml_update_dummy. Removed the `if (Wosize_val(dummy) == 0) {...}` branch (skip size-0 atoms), leaving `if (tag == Double_array_tag){`. Reverses fix.diff hunk `@@ -316,7 +316,17 @@ CAMLprim value caml_update_dummy` (runtime/alloc.c, now in obj.c). Changes/test hunks not applicable.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and oracle: pr12153 test fails (segfault, exit -11).
