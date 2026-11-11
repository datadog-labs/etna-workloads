# Rationale
Hunk: ocaml/typing/parmatch.ml, build_other: `mktag "AnyOtherTag"` -> `mktag "AnyExtraTag"`.
Reverses fix.diff hunk `@@ -980,7 +980,7 @@ let build_other_constant ...` (`any_extra_tag = "AnyExtraTag"` -> `"*any extra tag*"`);
today's code has no any_extra_tag binding, the name is inlined in mktag, so the old name is restored there.
Effect: the witness printed in non-exhaustive warnings uses the old name, which can also clash with a user tag.
Commands: make -j8 && make -j8 ocamltest && sh run-oracle.sh; final make clean + rebuild + oracle:
polyvars.ml => failed, poly.ml => passed.
