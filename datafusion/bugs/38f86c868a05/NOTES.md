Reproducer: cross join of two `generate_series(1, 3)` table functions, selecting only one column (`g1.value`).

Clean build: prints the 9 expected rows (1,1,1,2,2,2,3,3,3).
Buggy build: the generator ignores the projection and emits a 1-column batch where 0 columns are expected, so the query fails with
`Arrow error: Invalid argument error: Batch has 1 columns but BatchCoalescer expects 0`.
