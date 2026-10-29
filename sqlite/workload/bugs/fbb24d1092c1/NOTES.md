Reproducer: `x IN (y)` with a single-element list is rewritten to `x=y`. The injected bug adds a
BINARY collation to the right-hand side, so the column's NOCASE collation is lost.
Clean shell prints 1, 3, 4. The buggy shell omits 4 (`d IN ('FUZZ')` wrongly doesn't match).
