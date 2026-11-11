# Rationale
File typing/ctype.ml, `mcomp_fields`: removed the `has_present` helper and restored the old check
`if miss1 <> [] && object_row ty1 = Tnil || miss2 <> [] && object_row ty2 = Tnil then raise Incompatible`.
Reverses fix.diff hunk `@@ -2043,9 +2043,11 @@ and mcomp_fields type_pairs env ty1 ty2 =`.
(The mcomp_kind hunk was not reverted.)
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, and a final `make clean` rebuild.
Result: typing-objects-bugs/pr7284_bad.ml fails (ocamlc accepts the non-exhaustive program, exit 0 vs expected error).
