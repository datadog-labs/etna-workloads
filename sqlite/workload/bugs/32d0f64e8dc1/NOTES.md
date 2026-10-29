repro.sql: INTEGER-affinity column with NOCASE collation and an index, holding ' 1x' and ' 1-'.
`a LIKE ' 1%'` and `a LIKE ' 1-'` should each return the matching rows.
The buggy shell applies the LIKE range optimization even though the pattern starts with whitespace, so rows are missing from the results. The clean shell skips the optimization.
