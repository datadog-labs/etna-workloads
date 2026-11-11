# Rationale
Hunk: ocaml/stdlib/array.ml — replaced the bounds-checked `let sub a ofs len = if ... then invalid_arg "Array.sub" else unsafe_sub ...` with `let sub = unsafe_sub`. Reverses fix hunk `@@ -45,14 +45,19 @@ let make_matrix sx sy init =` (the added checked `sub`), so Array.sub is again unchecked (the C primitive).
(Kept the `unsafe_sub` name in the rest of the file; only the checked wrapper was removed.)
Commands: make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh -> tests/basic/arrays.ml failed (Test 8.x failures).
