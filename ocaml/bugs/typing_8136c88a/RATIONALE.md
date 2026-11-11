# Rationale
Fix reversed: `typing/typedecl.ml` hunk `@@ -138,8 +138,10 @@ let rec get_unboxed_type_representation`, which stripped `Tpoly` from the
field type of an unboxed record before `Ctype.apply`. In today's code this lives in
`typing/typedecl_unboxed.ml` as `let ty2 = Ctype.maybe_instance_poly ty2 in`.

Hunks:
1. typing/typedecl_unboxed.ml: removed that `maybe_instance_poly ty2` line (reverses the fix hunk above).
2. typing/typeopt.ml (scrape_ty): removed `|> Option.map Ctype.maybe_instance_poly` after
   `get_unboxed_type_representation`. Today this is a second place that strips Tpoly from the
   unboxed representation result; it masks hunk 1, so it must go too (same hunk of the fix, re-expressed).

The Changes/test hunks of fix.diff are not reverted (tests untouched).

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> with only hunk 1 the test passed (masked);
with both hunks tests/typing-unboxed-types/test.ml failed (expect output differs).
Final: `make clean && make -j8 && make -j8 ocamltest`, then run-oracle.sh -> failed.
