# Rationale

Fix: flattener could add an ORDER BY to the recursive part of a recursive query (dest SRT_Queue/Fifo...),
leaking it (and asserting), fixed by (1) deleting p->pOrderBy at end_of_recursive_query,
(2) making IgnorableOrderby() cover the queue destinations, (3) asserts.

Changes:
1. `src/select.c` generateWithRecursiveQuery: removed `sqlite3ExprListDelete(pParse->db, p->pOrderBy);` at
   `end_of_recursive_query` (reverses hunk 1). The ORDER BY the flattener put on p is overwritten and leaked.
2. `src/sqliteInt.h`: `IgnorableOrderby(X)` restored to `<=SRT_Discard` (the pre-fix narrower definition; reverses
   hunk 2, which made queue destinations ignore ORDER BY). So a Fifo/Queue destination sets up a sorter again.
3. `src/select.c` tag-select-0230 (omit superfluous ORDER BY on a joined FROM subquery, added in 2022): this later
   code covers the same case from another path (the view's ORDER BY is dropped before flattening, so the flattener
   never adds an ORDER BY to the recursive term). I gated it off for SRT_Fifo/SRT_DistFifo destinations (the
   recursive term of a UNION ALL / UNION), so the ORDER BY gets flattened into p as in 2014.

Oracle: with2-8.2 (UNION recursive step joining view `v` with ORDER BY) now aborts with an assertion
in selectInnerLoop (`eDest==SRT_Set || ...`) - the "assertion failure" the test's comment mentions; with2-8.3 and
later cases are not reached. Without (3) the oracle does not fail (and without (2) it only leaks).
