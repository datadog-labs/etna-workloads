# Rationale: constant-folding divide/modulo by zero (issue 43099)

The fix added `&& d != 0` to the constant-folding rules for division and
modulus on ARM, ARM64, MIPS and MIPS64 (the rules that fire at lowering time).
Folding `c/d` with `d == 0` makes the compiler itself panic with a
divide-by-zero.

## Changes
1. `_gen/ARM64.rules`, `ARM.rules`, `MIPS.rules`, `MIPS64.rules` (+ regenerated
   `rewriteARM64.go`, `rewriteARM.go`, `rewriteMIPS.go`, `rewriteMIPS64.go`):
   removed `&& d != 0` from the same rules the fix touched (DIV/UDIV/DIVW/UDIVW/
   MOD/UMOD/MODW/UMODW, CALLudiv Select0/1, MIPS DIV/DIVU Select0/1, MIPS64
   DIVV/DIVVU Select0/1). This reverses those fix hunks exactly.
2. `_gen/generic.rules` (+ regenerated `rewritegeneric.go`): removed
   `&& d != 0` from the integer `Div8..64(u)` and `Mod8..64(u)` const-fold rules.
   The oracle runs only on the host (amd64), where no lowering rule folds
   division, so reversing the arch hunks alone cannot fail the test. The
   generic rules are the "other path" that guards the same defect (the test's
   comment: "otherwise it gets handled in a different path"); same defect,
   same guard. Reverting them restores the crash on amd64.

## Oracle
`test/fixedbugs/issue43099.go` fails: the compiler panics (divide by zero in
the rewrite rule) in the SSA opt pass while compiling `f32`/`f64`/`f`, where
the divisor folds to constant 0.
