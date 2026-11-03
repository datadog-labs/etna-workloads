# Rationale

Changed `src/cmd/compile/internal/walk/compare.go`, in `walkCompare`'s `expr == nil` branch (0-size comparisons).

The fix replaced a shared temporary (`t := Temp(cmpl.Type())`, assigned from both `cmpl` and `cmpr`) with two blank assignments. go1.27.3 already had the blank-assignment form. I restored the pre-fix form, using `typecheck.TempAt(base.Pos, ir.CurFunc, ...)` because `typecheck.Temp` no longer exists. It is the same logic.

Because walkCompare strips OCONVNOP from both operands, `cmpr` can have a different type than `cmpl`. Assigning it to a temp of `cmpl`'s type then fails to typecheck.

Oracle: `Test/fixedbugs/issue52701.go` fails with `cannot use T2 value as type T1 in assignment`. This is the failure the fix guards against. `TestShouldTest` passes.
