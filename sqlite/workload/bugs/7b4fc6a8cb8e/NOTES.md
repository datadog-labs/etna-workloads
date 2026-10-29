Reproducer (repro.sql): builds t8 as in where-14.1 and runs the where-14.2 and where-14.7.1 queries.
With the bug, the ORDER BY terms are wrongly treated as satisfied by the loop order (the
`mTerm&~orderDistinctMask` check is dropped), so the sorter is skipped and rows come back in the wrong order.
