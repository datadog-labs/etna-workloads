# Rationale

Fix: EXPLAIN QUERY PLAN for row-value range constraints on an index
(src/wherecode.c, `explainAppendTerm` / `explainIndexRange`).

The fix made `explainAppendTerm` print all nBtm/nTop columns as `(c,d)>(?,?)`.
In 3.54.1 that helper is unchanged, so reversing the hunks does not apply cleanly.
The bug is restored at the call sites in `explainIndexRange`: the term count
passed for the lower bound (`pLoop->u.btree.nBtm`) and upper bound
(`pLoop->u.btree.nTop`) is replaced with `1`. This is the pre-fix behaviour,
where only the first column of the range was printed (`c>?`).

Oracle cases failing: rowvalue4-6.1 to 6.5. They get e.g. `(c=? AND d>?)`
instead of `(c=? AND (d,e)>(?,?))`.
