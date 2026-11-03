# Rationale

Fix hunk: noder/expr.go `selectorExpr` walked implicit field indices with
`fieldType.Field(ix)` instead of `deref(fieldType).Field(ix)`, so a pointer
receiver (e.g. `&A[T]{...}` with embedded interface field) broke the walk.

In go1.27.3 irgen's selectorExpr is gone; the equivalent walk over the implicit
field path is `writer.recvExpr` in src/cmd/compile/internal/noder/writer.go.
It uses `deref2(typ).Underlying().(*types2.Struct).Field(ix)`. I reverted it to
`typ.Underlying().(*types2.Struct)...`, dropping the pointer dereference, which
is exactly the pre-fix omission. (`methExpr` was left unchanged.)

Oracle: test/typeparam/issue48056.go fails: the compiler panics with
"interface conversion: syntax.Type is *types2.Pointer, not *types2.Struct"
(the check run crashes already while building runtime, since the same pattern
of selecting a promoted method through a pointer occurs there).
