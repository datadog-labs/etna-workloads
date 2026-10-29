Reproducer for collate8-3.x: a COLLATE inside a function's args or a CASE
must propagate up through the expression (sqlite3ExprCollSeq looks in Expr.x.pList).
repro.sql compares 'abc' to 'ABC'||f(... COLLATE nocase ...).
Clean prints 1,1,1; buggy ignores the collation and prints 0 for these.
