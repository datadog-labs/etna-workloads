# Rationale
File: ocaml/asmcomp/cmm_helpers.ml, `mk_not`.
Reverses hunk `@@ -292,8 +292,6 @@ let mk_not dbg cmm =` of asmcomp/cmmgen.ml, which removed the `Ccmpf` case
that negated a float comparison. In today's code that case exists but uses the NaN-correct
`negate_float_comparison`; I made it use a naive negation (CFlt -> CFge, etc.), so
`not (nan < 0.0)` is compiled as `nan >= 0.0` (false) in native code.
Only the code hunk is reversed (Changes and test hunks are not implementation).

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: float_compare.ml fails in native mode (output differs from reference), passes in bytecode.
