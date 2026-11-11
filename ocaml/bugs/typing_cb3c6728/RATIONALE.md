# Rationale
One hunk, ocaml/typing/parmatch.ml (build_other, polymorphic-variant case): removed
`if Btype.has_fixed_explanation row then some_private_tag else`, so for private/fixed rows the
counter-example tag is again a generated ordinary tag ("AnyOtherTag") instead of the special
`<some private tag>`. This reverses the fix.diff hunk `@@ -927,7 +929,7 @@ let build_other ext env` in typing/parmatch.ml
(`make_other_pat "AnyExtraTag"` -> `some_other_tag`; today's equivalent is some_private_tag).
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`:
polyvars.ml failed (message text differs from expected), poly.ml passed.
