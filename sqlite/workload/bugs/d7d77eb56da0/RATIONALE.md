# Rationale

Fix hunks reversed (all in `sqlite3ExprCodeIN`, src/expr.c). The 3.54.1 code already
has the fix in a different shape (single-column affinity special case, no `rLhsOrig`
at function scope), so the old behaviour was re-expressed locally:

- Fix hunk "if( eType!=IN_INDEX_ROWID ){ ... OP_Affinity before reordering": in the
  vector (`nVector>1`) case the `OP_Affinity` emitted before the aiMap reorder was
  removed, and an `OP_Affinity` over the reordered registers (with `zAff`, which is
  in the original LHS order) is emitted after the reorder instead. This is the
  pre-fix order of operations (affinity applied after columns are rearranged, so
  the wrong affinity lands on each column when aiMap is not the identity).
  The single-column path is untouched (reordering is a no-op there).

Oracle failure: `rowvalue-35.1` (`SELECT (1,'a') IN (SELECT c2,c1 FROM t1)` with
`t1(c1 TEXT, c2 INTEGER, PRIMARY KEY(c1,c2))`) returns 0 instead of 1: the TEXT
affinity is applied to the integer column and INTEGER to the text column.
