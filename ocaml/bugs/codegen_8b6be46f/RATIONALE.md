# Rationale
One hunk, ocaml/asmcomp/cmm_helpers.ml, `mod_int` (today's location of cmmgen.ml's mod_int).
Reverses fix.diff hunk `@@ -351,8 +351,8 @@ let mod_int c1 c2 dbg =`, which replaced the case
`(Cconst_int(0 | 1 | (-1)) as c1, c2) -> Csequence(c2, c1)` with `(Cconst_int 0, c2)`.
I re-added the case that returns the constant dividend 0/1/-1 for any divisor, so `1 mod n` is
always 1 (wrong when n = 1, and n = -1). The case is placed after the divisor 0/±1 cases and before the
const/const case.
The Changes entry and the test addition are not touched (test and Changes are out of scope).

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: tests/basic/divint.ml fails (native / ocamlopt run exits with code 2); the bytecode run passes.
