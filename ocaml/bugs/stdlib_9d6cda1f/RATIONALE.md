# Rationale
Hunk: ocaml/stdlib/float.ml, Float.Array.unsafe_blit. Replaced the external `caml_floatarray_blit` (memmove) with a forward element-by-element loop, reversing fix hunk `@@ -161,10 +161,8 @@ module Array = struct`. Overlapping blit with dst > src now corrupts data.
The runtime hunk (caml_floatarray_blit in array.c) is still used elsewhere in today's code, so it was left. Tests/Changes hunks not applicable.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> lib-floatarray/floatarray.ml fails (assertion at line 291).
