# Rationale

Fix: when block-sorting (partial sort) is used in a scalar subquery (LIMIT 1), exit the
loop as soon as the first valid output row is produced.

Changed hunk (src/select.c, pushOntoSorter): removed the
`if( iLimit ){ OP_IfNot iLimit, pSort->labelDone }` emitted right after
`OP_ResetSorter` in the block-output (nOBSat>0) path. This reverses the fix hunk that
added that jump to `labelDone`. The rest of the fix (labelDone field, iLimit hoisting,
generateSortTail using pSort->labelDone) is already present in 3.54.1 and is left untouched,
so the pre-fix behaviour (no early exit after the first block is flushed) is restored.

Oracle failure: `orderby1-9.0` (`SELECT (SELECT x||y FROM t2, t1 ORDER BY x, y)`) aborts with
`Assertion 'sqlite3BtreeCursorIsValid(pCur)' failed` in sqlite3VdbeExec, since the loop keeps
pushing rows after the LIMIT was satisfied. All other orderby1 cases pass.
