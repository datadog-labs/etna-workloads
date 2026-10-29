Subquery `SELECT t FROM t1 WHERE i=t ORDER BY t` (i INTEGER from outer query, t TEXT).
With the bug, the ORDER BY term is wrongly treated as satisfied by the equality despite the
affinity mismatch, so the wrong row is returned (clean: ' 1'; buggy: '1' via unsorted scan order).
