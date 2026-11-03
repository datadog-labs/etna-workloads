# Rationale

The fix (CL 346489) made method-expression import compute all methods of the
receiver base type (including those promoted through embedded fields) before
looking up the selection. The iimport path no longer exists in go1.27.3
(unified IR); the equivalent code is `typecheck.NewMethodExpr`
(src/cmd/compile/internal/typecheck/typecheck.go), which builds OMETHEXPR nodes.

Change: in `NewMethodExpr`, drop `CalcMethods(mt)` and look up in `mt.Methods()`
(declared methods only) instead of `mt.AllMethods()`. This reverses the fix's
"calculate all methods of the receiver base type before lookup" and restores the
bug: promoted methods through embedded fields are not found.

Oracle: test/fixedbugs/issue48088.go fails with
`a.go:18:6: internal compiler error: type T1 has no method M` for `T1.M`
where M is promoted via embedded *T2.
