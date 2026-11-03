# Rationale

Changed `src/cmd/compile/internal/ssagen/ssa.go` (`exprCheckPtr`, OINDEX case of a zero-length array, `bound == 0` branch).

This reverses the only implementation hunk of the fix. The fix replaced `return s.zeroVal(n.Type())` with `return s.load(n.Type(), s.constNil(n.Type().PtrTo()))`. I restored `s.zeroVal(n.Type())` and the original comment. The surrounding code had moved, but the hunk applies to the same logic.

`zeroVal` cannot handle non-SSAable types such as a struct containing an array. Indexing a `[0]S` array therefore ICEs.

## Oracle
`test/fixedbugs/issue77868.go` fails with `internal compiler error: 'f': zero for type [2]int not implemented`. This is the ICE the fix guards against. `TestShouldTest` passes.
