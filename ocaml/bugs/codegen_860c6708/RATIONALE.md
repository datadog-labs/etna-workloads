# Rationale
Hunk: ocaml/asmcomp/cmm_helpers.ml, `mod_int`. Added match case
`((Cconst_int ((0 | 1 | (-1)), _) as c1), c2) -> Csequence(c2, c1)` before the
const/const case. This reverses fix.diff hunk `@@ -349,8 +349,8 @@ let mod_int c1 c2 dbg =`
in asmcomp/cmmgen.ml (PR#6879 "Wrong optimization of 1 mod n"), which replaced that
case (0|1|-1 -> returns c1) with a 0-only case. (Today's code had no 0 case at all, so the
buggy case is re-added.) Now `1 mod n` folds to 1 even for n=1 / n=-1 wrongly... and e.g. `1 mod 2`... gives 1 whereas other values like -1 mod 2 etc. are wrong in native code.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: tests/basic/divint.ml fails in native mode (passes bytecode); bigstring tests pass.
