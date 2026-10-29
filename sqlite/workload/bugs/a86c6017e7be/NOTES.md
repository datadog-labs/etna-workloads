Reproducer: the upstream rowvalueA-3.3 case. A row-value comparison `(1234, x2.y) > (x1.a, x1.b)` is run against a table whose columns have different collations (b is NOCASE) and which has an index on a.
Clean shell returns the row `1234|abc|1234|ABCD`. The buggy shell picks the wrong collation in whereRangeVectorLen and returns no rows.
