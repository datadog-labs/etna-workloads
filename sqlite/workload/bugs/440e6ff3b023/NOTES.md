Creates t1(a,b) with indexes on a and b, then runs EXPLAIN QUERY PLAN on
`likelihood(a=?, 0.014) AND b BETWEEN ? AND ?` (cost-4.2 from test/cost.test).
Clean shell picks `SEARCH t1 USING INDEX i1 (a=?)`; buggy shell wrongly picks
`SEARCH t1 USING INDEX i2 (b>? AND b<?)` because the range-scan nOut estimate
is not restored to its saved value after whereLoopInsert.
