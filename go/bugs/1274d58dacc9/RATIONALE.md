# Rationale

In go1.27.3 `pendingType`/`finiteSize` no longer exist. The same invariant ("don't observe a value of a type still pending on the object path") is enforced by `Checker.isComplete` (types2/cycles.go), which walks through names/RHS (`type A B; type B [unsafe.Sizeof(A{})]int`) and reports a cycle. The pre-fix code (`pendingType`) only checked whether the operand's own Named type was directly on `objPath`, and did not look through the RHS (arrays/structs/named chains).

Change (types2/cycles.go, `isComplete`): drop the recursion through `fromRHS`; only the type's own object is checked against `objPathIdx`, then `return true`. This reverses the fix hunk in expr.go (`pendingType` going from a direct-Named check to the recursive `finiteSize` walk through Named/Array/Struct).

Oracle: `TestFixedbugs/issue76478.go` fails (B{} where B -> A pending is no longer reported, leading to a panic from calling Underlying on an incomplete type, which aborts the test binary; this is why many other cases in the package are also reported failing). issue75918 (S{} with S struct{a A}, A pending) is the same defect.
