# Rationale (golang/go#65455: NewAlias must set Alias.actual)

Changes (all under src/cmd/compile/internal/):

1. types2/alias.go `NewAlias`: removed the `alias.cleanup()` call (fix's `unalias(alias)` "Ensure that alias.actual is set"); returns `newAlias(obj, rhs)` directly, as pre-fix.
2. types2/alias.go `Alias.Underlying`: `unalias(a).Underlying()` -> `a.actual.Underlying()` (fix hunk), so an alias from the public NewAlias has nil actual and panics.
3. Supporting changes, needed because go1.27.3 internals call `Underlying()` directly on aliases and relied on the lazy setter (pre-fix code relied on Unalias elsewhere), so the compiler itself crashed with only 1+2. These keep internal alias creators setting `actual` themselves, leaving only the public NewAlias API buggy:
   - types2/decl.go: `unalias(alias)` after `alias.fromRHS = rhs` (and in the invalid-RHS fallback, clearing `actual` first).
   - types2/alias.go `newAliasInstance`: `unalias(res)`.
   - types2/universe.go: `unalias(NewAlias(... any ...))`.
   - importer/ureader.go: `types2.Unalias(a)` after NewAlias/SetTypeParams.

Oracle: `TestNewAlias_Issue65455` fails with nil pointer dereference at alias.go `Alias.Underlying` (actual == nil), exactly what the fix test guards. The panic aborts the test binary, so the remaining oracle cases are reported failing as well (incomplete run).
