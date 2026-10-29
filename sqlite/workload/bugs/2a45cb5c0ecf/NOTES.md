Creates a partial index `i8c ON t8b(y) WHERE x='value'` and runs EXPLAIN QUERY PLAN on
`t8a LEFT JOIN t8b ON (x='value' AND y=a)`. The clean shell uses the partial index
(`SEARCH t8b USING INDEX i8c (y=?) LEFT-JOIN`); the buggy shell, which no longer
considers ON-clause terms of the matching join, picks a different plan (see check.sh output).
