`repro.sql` is test pushdown-4.1: `t1 JOIN t2 ON false RIGHT JOIN t3 ON true CROSS JOIN v6`, where v6 is a view containing a RIGHT JOIN.

Clean shell: prints one row, `-|-|3|-|5`.
Buggy shell: prints no rows. The ON-clause term `false` from the left side of the RIGHT JOIN is pushed down into the subquery on the right side, which filters out its row.
