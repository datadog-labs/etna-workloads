Reproducer (repro.sql): the joinH-12 setup plus the query
`t1 LEFT JOIN t2 ON true RIGHT JOIN t3 ON d2=e3 WHERE c2 BETWEEN NULL AND a1`.

Clean shell: returns no rows (the WHERE is NULL for every row).
Buggy shell: returns the row `88||88||`. The RIGHT JOIN strength-reduction code clears
JT_LTORJ on too many tables (loop runs down to 0 instead of i), so the join is handled wrongly.
