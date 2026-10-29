repro.sql: creates t0, t1, t2 and runs `t0 JOIN t1 ON (t2.x NOTNULL) LEFT JOIN t2 ON false`.
The INNER JOIN's ON clause refers to t2, which is to its right. SQLite treats that term as a WHERE term.
Clean shell: no rows (correct, since t2.x is NULL when the LEFT JOIN finds no match). Buggy shell: returns the row `t|u|v|w||`.
The fix clears EP_InnerON on such terms. The injection removes that, so the term is applied at the wrong point in the loop nest.
