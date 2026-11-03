# Rationale

Fix hunk reversed: `types2/operand.go` `assignableTo` (the go/types hunk is outside the allowed scope).

The fix replaced an early return in the "T is an interface" branch with logic that
falls through when V is a type parameter (V may be assignable to T via its core type).
The code in go1.27.3 still had that fix, so I restored the pre-fix form: if T is an
interface (non-type-parameter) or pointer to interface and `implements` fails, return
`false, InvalidIfaceAssign` unconditionally; otherwise return true.

Oracle cases expected to fail: `TestFixedbugs/issue54424.go` (`var p P; var tp *T; tp = p`
with `P ~*T` is wrongly rejected, since `isInterfacePtr(Tu)` is true for `*T` with
T a type parameter constrained by `any`) and other tests that include it (TestFixedbugs, etc.).
