# Rationale

Fix (types2 hunks of 27316739): `unsafe.Slice` and `unsafe.SliceData` in
`src/cmd/compile/internal/types2/builtins.go` used `under(x.typ)` and the fix
changed that to `coreType(x.typ)`. In go1.27.3 `coreType` has been replaced by
`commonUnder(x.typ(), nil)`, so I reverted both sites to
`x.typ().Underlying().(*Pointer)` / `.(*Slice)`, the pre-fix behaviour. For a
type parameter, `Underlying()` is its constraint interface, so `S ~[]E` and
`S ~*E` are rejected as "not a slice" / "not a pointer".

The go/types hunks have no counterpart here, because go/types is outside src/cmd/compile.

Failing oracle cases: `TestFixedbugs/issue64406.go` (and its parent
`TestFixedbugs`) in cmd/compile/internal/types2. They fail with spurious errors
on `unsafe.SliceData(s)` and `unsafe.Slice(s, 0)` for type-parameter arguments.
