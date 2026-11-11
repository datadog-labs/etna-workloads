# Rationale
One hunk, `ocaml/typing/includemod.ml`, function `check_modtype_equiv`: in the reverse-direction check (`c2`), removed `let direction = Directionality.negate direction in`, so the reverse check uses the same marking direction instead of the negated one.
This reverses fix.diff hunk `@@ -742,7 +742,9 @@ and check_modtype_equiv ~in_eq ~loc env ~mark mty1 mty2 =` (which added `let mark = negate_mark mark in`). In today's code the mark is carried by `Directionality`, and `negate` is the equivalent.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: tests/warnings/w32.ml fails (spurious "Warning 32: unused value x" for the module type S).
