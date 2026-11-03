# Rationale

Fix (#52635): `arrayClear` did not recognise `for i := range p { p[i] = 0 }` when `p` is a
pointer to an array, because the body's `lhs.X` is the implicit/explicit `*p` (ODEREF) while
the range expression `a` is `p`; the fix strips the ODEREF from `lhs.X` before `SameSafeExpr`.

In go1.27.3 the code was reorganised (`arrayRangeClear` in walk/range.go). Ranges over arrays
or pointers to arrays with a constant length reach it as a constant int `a`; the array case
is matched by `x.Type().IsArray()` and `x.Type().NumElem() == n`, with `x` being the
dereferenced array (`*t.a`). That is the descendant of the fix's "strip the ODEREF" hunk.

## Change (walk/range.go, arrayRangeClear)
`if !x.Type().IsArray() || x.Op() == ir.ODEREF { return nil }` in the Int/Array case:
a loop body indexing through a dereferenced pointer-to-array (`*t.a`, the implicit deref
of `t.a[i]`) is no longer accepted, i.e. pointers to arrays are unsupported again, as before the fix.

Caveat: the range expression is now a literal, so pointer-ness of the range operand cannot
be told apart; `range *t.a` (case 2/4, which worked even before the fix) is also affected.

## Oracle
test/codegen/issue52635.go fails (`Test`, `Test/codegen/issue52635.go`): the four pointer-to-array
loops (lines 22, 28, 34, 40) are no longer cleared (no `MOVUPS X15,`), while `t.b` (plain array) and the slice case still are.
