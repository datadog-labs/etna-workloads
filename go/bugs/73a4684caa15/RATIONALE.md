# Rationale

Fix hunk reversed: types2/infer.go, `tpWalker.isParameterized` `case *Tuple`.
The fix added the case (`return t != nil && w.varList(t.vars)`). In go1.27.3 the
code is identical, so I restored the pre-fix commented-out stub. Tuples then
reach the default case, which panics. `Checker.callExpr` calls
`isParameterized(tparams, x.typ())` with a result tuple when inference fails.
That is the path from go.dev/issue/59890.

The fix's other hunks only fix a comment spelling ("parametrized") and change
go/types. go/types is outside src/cmd/compile, so I left it alone.

Oracle: TestFixedbugs/issue59890.go fails (panic on an unexpected Tuple type in
isParameterized). The panic aborts the whole test binary, so the other 174
cases listed as failing are collateral.
