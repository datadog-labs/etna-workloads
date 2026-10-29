repro.sql runs the where2-14.1 case: `SELECT x FROM t14a WHERE x NOT IN (SELECT x FROM t14b)`.
The subquery's `x` is a correlated reference to t14a, so the result must be empty.
The clean shell prints nothing. The buggy shell treats the correlated subquery as an
uncorrelated index lookup and returns the rows 2, 3, 4.
