# Rationale

Both changes are in src/cmd/compile/internal/noder/writer.go.

1. `typIdx`, `case *types2.Alias`: reverses the hunk that switched to `w.namedType(splitAlias(typ))`.
   Restored the pre-fix `w.namedType(typ.Obj(), nil)`, so an instantiated generic alias is written without its type arguments.
   `splitAlias` is left in place (unused by this path, still used elsewhere).
2. `objTypeParams`: reverses the hunk that added the `*types2.Alias` case returning `alias.TypeParams()`.
   The alias case is removed, so a generic alias reports no type parameters.

Failing oracle case: `Test/fixedbugs/issue68054.go` fails with
`internal compiler error: panic: runtime error: index out of range [0] with length 0` at `var _ A[int]`.
`TestShouldTest` passes.
