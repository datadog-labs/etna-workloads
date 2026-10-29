# Rationale

Changed `sqlite3ExprAnd()` in `tree/src/expr.c`, reversing the fix hunk in the same function.

- The fix added `&& !IN_RENAME_OBJECT` to the "AND 0" shortcut and replaced the
  unmapping delete with a plain delete, so that ALTER TABLE keeps both operands
  and renames identifiers inside them. In 3.54.1 the guard is the same
  `!IN_RENAME_OBJECT` and the delete is `sqlite3ExprDeferredDelete`.
- Pre-fix code, restored: no `!IN_RENAME_OBJECT` guard, and both operands go
  through `sqlite3ExprUnmapAndDelete()` (the pre-fix call). That call removes the
  operands from the rename map when renaming, which is the old behaviour.
  So the operand tokens are dropped from the rewrite and never renamed.

## Failing oracle cases
`altertab3-24.2` and `altertab3-24.4`. The expected rename error is not raised
(24.2), and `0 AND (SELECT rowid FROM v0)` is not renamed to `xyz` (24.4).
