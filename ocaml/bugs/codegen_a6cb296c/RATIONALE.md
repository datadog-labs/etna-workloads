# Rationale
One hunk, in `ocaml/asmcomp/cmm_helpers.ml` (`mk_not`, the `Cop(Ccmpf cmp, ...)` case).
It reverses the fix.diff hunk `@@ -292,8 +292,6 @@ let mk_not dbg cmm =` in asmcomp/cmmgen.ml.
That hunk removed the case that commuted negation with float comparison.
In today's code the case exists but uses NaN-aware `negate_float_comparison` (lt -> nlt).
I replaced it with the naive negation (lt -> ge, le -> gt, etc.), so `not (nan < 0.)` compiles to `nan >= 0.`, which is false.

Commands run:
`cd ocaml && make clean && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
Result: float_compare.ml fails for native (output shows `1. !< nan: false`) and passes for bytecode.
