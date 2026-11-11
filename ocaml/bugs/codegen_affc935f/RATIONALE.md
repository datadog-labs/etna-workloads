# Rationale
Bug: zero-sized float arrays not having tag 0 (GPR#1075).

Hunks:
1. ocaml/asmcomp/cmm_helpers.ml (`floatarray_header`; cmmgen.ml's code moved here): removed the
   `assert (len >= 0)` and `len = 0 -> block_header 0 0` case. Reverses fix hunk `@@ -96,7 +96,11 @@ let black_closure_header` in asmcomp/cmmgen.ml.
2. ocaml/runtime/alloc.c `caml_alloc_float_array`: zero-size now returns Atom(Double_array_tag) instead of Atom(0)
   (comment removed). Reverses `@@ -158,6 +158,9 @@ CAMLprim value caml_alloc_float_array` in byterun/alloc.c (that hunk
   was a comment documenting the zero tag; in today's code the behaviour itself is what is undone).
3. ocaml/runtime/array.c `caml_floatarray_make_unboxed`: removed the `size == 0 -> Atom(0)` early return, so
   Array.make 0 0.0 gives a tag-254 empty block. Same fix hunk as 2 (runtime half of the zero-tag invariant);
   this is what makes the test fail, since hunk 1 isn't reached by non-flambda closure for `[||]`.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
zero_sized_float_arrays.ml => failed (bytecode run exit code 2, assertion).
