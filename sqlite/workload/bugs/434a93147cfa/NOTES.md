Reproducer: ORDER BY random() with a constant-bound join (x2.x=1). The buggy shell treats the
non-deterministic random() as satisfied by the loop order and drops the sorter; the EXPLAIN output
has no SorterOpen or random call, whereas the clean shell keeps them.
