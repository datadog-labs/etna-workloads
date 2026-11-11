# Rationale
Fix reversed: "propagate type information to patterns, even with polymorphic variants" (2013-01-11).

Edits (ocaml/typing/typecore.ml):
1. Removed the `check_absent_variant` function — reverses hunk `@@ -1691,6 +1713,24 @@ let contains_gadt env p =` (which added it).
2. Removed the `List.iter ... check_absent_variant ...` call in `unused_check` of type_cases — reverses hunk `@@ -3137,7 +3181,11 @@ and type_cases` (delayed check calling check_absent_variant). Matching against absent constructors is allowed again.

(The other hunks, e.g. erase_either/ctype partial copy, were left as-is; fully reverting propagation broke the self-hosted build of env.ml.)

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> polyvars.ml and/or test.ml fail (see run output: test.ml/polyvars.ml reference mismatch).
