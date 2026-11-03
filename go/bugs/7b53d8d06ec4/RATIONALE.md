# Rationale

Fix hunk reversed: types2/named.go `resolve()`: "advance state to `loaded` before calling delayed functions".
In go1.27.3 this is `unpack()` in types2/named.go, where the state is set to
`lazyLoaded|unpacked|hasMethods|hasUnder` before running the loader's `delayed` funcs.
I moved that `setState` after the loop, so the delayed `SetConstraint` calls run while `n.mu` is held and
state is still unset. A constraint that refers back to the loaded type (e.g. `type A[_ B[any]]`, `B[_ any] interface{ f() A[B[any]] }`)
calls `unpack()` on it, tries `n.mu.Lock()` again and deadlocks (issue 63285).

Only types2/named.go changed. The importer-side delayed mechanism is left intact (it is what makes the deadlock reachable).

Oracle: importer TestIssue63285 (and other importer tests that load generic types with self-referential constraints) hang/deadlock.
