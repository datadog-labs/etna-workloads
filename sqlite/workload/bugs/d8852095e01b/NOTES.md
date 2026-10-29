EXPLAIN QUERY PLAN for `a NOT IN private` (IN against a table's rowid) should include
`USING ROWID SEARCH ON TABLE private FOR IN-OPERATOR`. The buggy shell omits that line.
