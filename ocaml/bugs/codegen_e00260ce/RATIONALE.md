# Rationale
Bug: zero-sized float arrays got tag Double_array_tag instead of 0 (fix GPR#1075).

1. `ocaml/asmcomp/cmm_helpers.ml` (`floatarray_header`): removed the `len = 0` special case (and assert), reversing hunk `@@ -96,7 +96,11 @@ let black_closure_header ...` of asmcomp/cmmgen.ml (code since moved to cmm_helpers.ml).
2. `ocaml/middle_end/closure/closure.ml`: empty `Pmakearray (Pfloatarray, _)` now becomes `Uconst_float_array []` (emitted with the double-array tag, size 0) rather than `Uconst_block (0, [])`. This is today's equivalent of the same hunk: the empty float array constant is now emitted with a nonzero tag. (Hunk of byterun/alloc.c was comment-only.)

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> zero_sized_float_arrays.ml fails natively (Assert_failure at line 16), bytecode passes.

RESULT: injected
