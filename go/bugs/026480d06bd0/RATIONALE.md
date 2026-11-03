# Rationale

Fix hunk: `Sym.Less` in types/sym.go gained a "nil before non-nil" check so that
sorting interface methods with nil Syms (embedded anonymous types) doesn't dereference nil.

In go1.27.3 this function is `CompareSyms` (same file). I removed its
`// Nil before non-nil` block (`a == nil -> -1`, `b == nil -> +1`), restoring the pre-fix
behaviour. The `a == b` early return remains, as it did before the fix.

Oracle: `test/fixedbugs/issue46556.go` fails with
`internal compiler error: panic: runtime error: invalid memory address or nil pointer dereference`
at `type C interface { A; B }` (line 13). `TestShouldTest` passes, as expected.
