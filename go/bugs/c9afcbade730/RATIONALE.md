# Rationale

Fix: types2 required the iterator yield result to be exactly `bool` (via `Identical(..., universeBool)`), instead of any boolean type (`isBoolean`), to avoid a compiler panic (#71131).

In go1.27.3 the check lives in `src/cmd/compile/internal/types2/range.go` (moved out of stmt.go's `rangeKeyVal`).

Changes (only types2 is under src/cmd/compile; go/types is outside scope):
- `types2/range.go`: reversed the stmt.go hunk. The condition is back to `!isBoolean(cb.Results().At(0).Type())`, and the "user-defined boolean, not bool" branch is removed.
- `types2/universe.go`: removed `universeBool` and its init, reversing the universe.go hunk. It is no longer used.

Oracle failures: `TestFixedbugs/issue71131.go` (and parent `TestFixedbugs`) in types2. The type checker now accepts `func(func() Bool)` with `type Bool bool`, so the expected "yield func returns user-defined boolean, not bool" errors are missing.
