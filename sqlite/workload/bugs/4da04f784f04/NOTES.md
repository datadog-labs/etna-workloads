Reproducer (`repro.sql`): a LEFT JOIN whose right table has an index on `(y, ifnull(z,'!!!'))`.
The query `SELECT ifnull(z,'!!!') FROM t3 LEFT JOIN t4 ON x=y` should return `!!!`.
Clean shell prints `!!!`; the buggy shell prints an empty row (NULL) because the expression is
read from the index while the cursor is on a null-row (bMaybeNullRow forced to 0).
