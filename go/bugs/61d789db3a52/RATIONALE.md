# Rationale (issue 49276)

The fix added a guard in the struct case of composite-literal checking (`utyp.fields == nil` -> "illegal cycle in type declaration") so a struct literal of a not-yet-set-up struct type doesn't crash. In go1.27.3 this was redesigned: `Checker.isComplete` (cycles.go) is called once at the top of `compositeLit` (literals.go) for all literal types. The `markComplete` hunks in struct.go/subst.go still exist but are only bookkeeping.

## Changed
`src/cmd/compile/internal/types2/literals.go`: removed the `if !check.isComplete(base) { x.invalidate(); return }` check in `compositeLit`. This reverses the fix's expr.go hunk (the guard against literals of incomplete types, which now covers structs through this generic path). The same check also covers arrays etc. (the "analogous" *Array guard mentioned in the fix), so those lose it too.

## Oracle
Running `unsafe.Sizeof(A{})`-style cycles in the testdata (cycles*.go, issue49276-like cases) now panics inside types2 `Config.Check`, which fails TestCheck and many dependent cases (457 of 592 cases fail because the panic aborts the package test binary).
