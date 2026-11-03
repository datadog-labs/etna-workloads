# Rationale

Fix hunks reversed (the fix's go/types hunk has no counterpart in the cmd/compile tree; testdata hunks are tests):

1. `types2/expr.go` hunk -> now `types2/literals.go`, `case hint != nil` in the composite literal check.
   The fix replaced `base = typ; if !isTypeParam(typ) { base = under(typ) }; deref(base)` with
   `deref(structuralType(typ))`. In go1.27.3 the equivalent is `commonUnder` + `deref`. I restored the
   pre-fix computation: for a type parameter the base stays the type parameter itself (no look through
   to its structural type), so `[]P{{f: 1}}` with `P *S` is rejected.
2. `noder/writer.go` hunk -> `writer.compLit`: the pointer check goes back from `types2.CoreType(typ)`
   to `typ.Underlying()`. This only matters once the type checker accepts the literal; it is the same
   defect, because a type parameter with a pointer core type is then not dereferenced.
   (The fix's `irgen.compLit` in noder/expr.go no longer exists, since the unified IR replaced it.)

## Oracle failures
`Test/typeparam/issue50833.go` fails with `invalid composite literal element type P` on
`func c[P *S]() []P { return []P{{f: 1}} }` and the `d[P PS]` variant. The types2 testdata
`issue50833.go2` cases fail for the same reason.
