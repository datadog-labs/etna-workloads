# Rationale
File: ocaml/asmcomp/cmm_helpers.ml, `unbox_float` (the code moved from cmmgen.ml).
Reverses hunk `@@ -547,7 +547,8 @@ let map_ccatch ...` (`let rec unbox_float`): the Calloc case again matches any
allocation `[_; c]` rather than only those with the float header, so a non-float
block allocation (e.g. `Some i`) is wrongly unboxed as a float.
The boxed-int hunks (alloc_matches_boxed_int) were not reverted; the fix says they were preventative only.
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh`
Result: unbox_under_assign.ml fails (native compile fails); bytecode passes.
