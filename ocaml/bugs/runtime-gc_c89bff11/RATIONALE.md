# Rationale
One hunk, runtime/major_gc.c, in `caml_darken`: removed the `mark_work_done_between_slices += 1` / `+= Whsize_hd(hd)` accounting.
Reverses fix.diff hunk `@@ -1524,6 +1540,9 @@ void caml_darken(void* state, value v, volatile value* ignored) {`.
Extra marking work from caml_darken (write barrier) no longer counts, so GC cycles finish too fast.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: tests/misc/darkening_work.ml fails ("error: writes caused 57 more cycles").
