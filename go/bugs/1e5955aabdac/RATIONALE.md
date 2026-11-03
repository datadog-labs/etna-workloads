# Rationale

Fix (issue 59378): `typecheckrangeExpr` in typecheck/stmt.go changed
`if ir.DeclaredBy(nn, n)` to `if ir.DeclaredBy(nn, n) && nn.Type() == nil`, so a
range key/value that unified IR had already typed was not retyped.

In go1.27.3 `typecheckrangeExpr` and its `do` closure no longer exist; `tcRange`
only typechecks the nodes. So the pre-fix behaviour (unconditionally calling
`SetType` on declared key/value from the range expression's type) is
re-expressed at the top of `tcRange` in src/cmd/compile/internal/typecheck/stmt.go.
It has the same `ir.DeclaredBy(nn, n)` guard and no `nn.Type() == nil` check, and
derives key/value types from `n.X` as the old `do` calls did (array/slice/ptr-to-array,
map, chan, string).

## Oracle failure
test/fixedbugs/issue59378.go fails with
`internal compiler error: cannot call SetType(go.shape.int) on v (type int)`,
because the key/value is retyped with the shaped type while unified IR already
recorded `int`.
