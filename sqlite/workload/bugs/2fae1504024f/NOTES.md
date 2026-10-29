Reproducer (repro.sql): creates t8, then a view `NTILE(256) OVER (ORDER BY total) - 1`, and selects from it.
The buggy exprDup() doesn't advance its buffer pointer for non-reduced nodes, so the view's
duplicated window-function expression is corrupted.
Clean: rows 0,1,2. Buggy: 0,0,0 plus "Memory leaked: 896 bytes".
