repro.sql: index on constant expression `NULL` plus a query with a LEFT JOIN chain over a DISTINCT view and `WHERE c2/0.1`
(whereL-810). Clean shell returns the row `0.2|||0.2`; buggy shell (constant-index check weakened in
exprMightBeIndexed2) returns no rows.
