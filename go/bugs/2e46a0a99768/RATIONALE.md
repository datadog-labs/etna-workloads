# Rationale

The fix (#51522) made switches whose tag or case values involve a type parameter
convert both sides to `interface{}` before comparison. In go1.27.3 stenciling
(`stencil.go`) no longer exists. The equivalent logic is in the unified IR
writer, `writer.switchStmt` (src/cmd/compile/internal/noder/writer.go), which
promotes the tag type to `any` when a case can't be assigned to it and either
side is an interface (type parameters count as interfaces in types2).

## Change
Added `!isTypeParam(tagType) &&` to that promotion condition. This reintroduces
the original defect: a switch on a type-parameter-typed tag is no longer
converted to `interface{}`, so cases of interface type are compared without the
conversion. This reverses the `OSWITCH` hunk of stencil.go (the tag/case
conversion to `interface{}`); the other hunk is a comment change.

## Oracle
`test/typeparam/issue51522b.go` fails: `switch t { case i: }` with `t T` and
`i any` gives `internal compiler error: any is not assignable to T`.
