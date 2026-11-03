# Rationale: issue 53600 (prove: induction variable with `<= maxint` bound)

## Hunk 1: `src/cmd/compile/internal/ssa/loopbce.go` (reverses the fix's only hunk)
The fix added a `continue` for `<=` loops whose constant max can't be incremented by
`step` without overflow. In go1.27.3 that check lives in the `step > 0` const-limit
branch of `ok()`: `addWillOverflow(v, step, maxSignedValue(ind.Type))`, where `v` is the
last value the loop reaches. I restricted it to `!inclusive`, so inclusive (`<=`) loops
are accepted again without the overflow check, as before the fix.

## Hunk 2: `_gen/generic.rules` + regenerated `rewritegeneric.go`
Today `(Leq64 _ (Const64 [math.MaxInt64])) => (ConstBool [true])` folds the test's
`i <= math.MaxInt64` before prove, so findIndVar never sees the loop and hunk 1 alone
has no effect. Removing this rule (64-bit only) lets the comparison reach findIndVar, as it
did when the bug existed. This is a second path covering the same case, and it
only matters for the same defect.

## Result
With both changes, `test/fixedbugs/issue53600.go` is miscompiled: prove records
`MaxInt64 <= i <= MaxInt64` for the induction variable and removes the `i < 0` exit, so
the loop never prints "done" and spins forever printing `9223372036854775807 false`
(the expected output is the `.out` file). `check.sh` hangs on this oracle (timeout), which
is the failure. I confirmed it by building the test directly.
