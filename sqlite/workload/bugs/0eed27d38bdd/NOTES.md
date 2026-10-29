Reproducer: `repro.sql` (joinH-11.3). It runs `t1 LEFT JOIN t2 RIGHT JOIN t3 ON (t2.c=10) WHERE t1.a=1`.

Clean shell: the second query returns no rows. Buggy shell: it returns the row `1|1|||3|3`.

With the injected patch, the join-strength-reduction code no longer calls `unsetJoinExpr` for the right cursors when LEFT and RIGHT joins are mixed. The ON-clause terms are therefore handled wrongly and an extra row comes back.
