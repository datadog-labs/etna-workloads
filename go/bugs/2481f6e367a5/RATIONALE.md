# Rationale

The fix changed `selectorExpr` in noder/expr.go (the irgen/stenciling frontend) so that, for a method
reached through an embedded field, the receiver's instantiated type arguments were used instead of the
base receiver's type params (`getTargs(selinfo)` / `xt.RParams()`). That frontend no longer exists in
go1.27.3; only unified IR remains.

## Change: src/cmd/compile/internal/noder/writer.go, `methodExpr`
For a concrete method selected through an embedded field (`len(sel.Index()) > 1`), the receiver type
arguments (`tExplicits`) are now taken from the type params of the method's declared (origin) receiver,
`fun.Origin()...RecvTypeParams()`, instead of the instantiated receiver's type args from `splitNamed(recv)`.
This is the same defect as the fix reversed: passing the base receiver's type params rather than the
instantiated type for an embedded receiver.

## Oracle failures
- test/typeparam/issue47797.go: compiler ICE (index out of range) in `foo` for `b.Bat()`.
- test/typeparam/issue48253.go: compiler ICE (index out of range) in `main` for `Foo{}.Bat()` etc.
