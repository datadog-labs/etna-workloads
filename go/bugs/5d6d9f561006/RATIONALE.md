# Rationale

Fix hunk reversed: `compLit` in noder/expr.go changed `typ.Underlying().(*types2.Struct)` to
`types2.Structure(typ).(*types2.Struct)` (a type param constrained to a single struct type was
not recognised as a struct literal). noder/expr.go no longer exists; the unified-IR equivalent
is `writer.compLit` in noder/writer.go, which now dispatches on `types2.CoreType(typ)` (the
successor of `Structure`).

Change: in the `*types2.Struct` case of the compact-literal switch, struct-ness is again decided
by `typ0.Underlying().(*types2.Struct)` (the pre-fix computation). For a type parameter the
underlying type is its constraint interface, so the check fails and the compiler reports an
internal error. Other cases (slice/map/array via CoreType) are untouched, so the standard
library still builds.

Oracle: test/typeparam/issue48538.go fails with
`internal compiler error: unexpected composite literal type: T` (f and f2 with `T{b1:..., b2:...}`
for T constrained to a struct).
