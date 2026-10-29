repro.sql builds a table with index i3(a ASC, b DESC, c ASC) and runs `WHERE a=2 AND b>'two'`,
`b>='two'`, and `a>2 ORDER BY a`; these seek the index with a prefix key on a DESC column.
Clean: `b>'two'` returns 2.2; `b>='two'` returns 2.2 2.0 2.1; `a>2` returns 3.0.
Buggy: the incomplete-key comparison flips default_rc for DESC columns, so `b>'two'`
returns nothing (the 2.2 row is lost); the other two queries match.
