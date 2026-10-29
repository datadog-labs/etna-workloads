Reproducer (`repro.sql`): join8-18010 in SQL. t1(a) has an index; the query
`t2 RIGHT JOIN t1 ON true WHERE (x NOTNULL)=a` must return no rows.
With the bug, the WHERE constraint on `a` drives the t1 index, so the
clean shell prints nothing while the buggy shell prints a row `|0|0|1`.
