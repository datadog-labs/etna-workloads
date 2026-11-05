# Rationale
Identity handling is moved out of `build_column_default()` back into callers (the pre-fix state); ADD COLUMN again uses plain `build_column_default()`.

- `src/backend/rewrite/rewriteHandler.c`, `build_column_default()`: removed the `attidentity` NextValueExpr branch (fix.patch rewriteHandler.c hunk 2). Callers that don't special-case identity now get NULL defaults.
- `rewriteHandler.c`, `rewriteTargetListIU()`: re-added the identity NextValueExpr branch (rewriteHandler.c hunk 1), so INSERT still works.
- `src/backend/commands/copyfrom.c`, `BeginCopyFrom()`: re-added the inline identity NextValueExpr (+ `catalog/dependency.h` include) (copy.c hunk).
  This is the code the fix removed, so COPY behaves as it did before.
- `src/backend/commands/tablecmds.c`, `ATExecAddColumn()`: removed the manual identity NextValueExpr using `identitySequence` (tablecmds.c hunk). ADD COLUMN ... IDENTITY on a non-empty table, which relied on that, now fills existing rows with NULL.
  The `identitySequence` field and its node/parser plumbing are left in place, because they are now unused and harmless.

Failing oracle cases (from the oracle run):
- src/test/regress||identity
- subscription 008_diff_schema: check extra columns contain local defaults after apply
- subscription 008_diff_schema: check replicated inserts on subscriber

The last build with the copyfrom.c edit compiled, but the oracle run was cut off by a timeout before printing results. The results above come from the run just before that edit.
