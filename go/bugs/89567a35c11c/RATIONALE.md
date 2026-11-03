# Rationale

Fix (issue 59572): `ir.reassigned` ignored range statements, so `for _, fn = range list` was not seen as reassigning `fn`. `StaticValue(fn)` then returned `foo`, and the call was wrongly devirtualized or inlined.

## Change
`src/cmd/compile/internal/ir/expr.go`, in `reassigned`: removed the `case ORANGE:` branch that returns true when `n.Key` or `n.Value` is the name. This is exactly the hunk the fix added, so the code is equivalent to the pre-fix version.

I did not revert the similar `ORANGE` case in `reassignment.go` (`ReassignOracle`). It was added later and is not part of this fix. Reverting `expr.go` alone is enough to bring the bug back.

## Oracle
`test/fixedbugs/issue59572.go` fails. It prints `foo foo foo` instead of `1 2 3`.
