# Rationale

Fix hunk (src/where.c, whereLoopAddBtreeIndex): added a loop that sets `nIn = 0`
when an earlier term of the WhereLoop already references the same
`(x,y) IN (SELECT...)` expression, so the 25-row (LogEst 46) multiplier is applied
once rather than once per vector column.

In 3.54.1 this loop still exists (with an added `bRedundant` check). I removed the
`nIn = 0;` assignment inside it (src/where.c ~line 3350), keeping the redundancy
detection. nIn stays 46 for every column term of the vector IN, so the multiplier
is applied once per column: the pre-fix behaviour. The assert-move hunk is cosmetic.

Oracle: rowvalue4-5.1 fails (EQP plan for the `(a,b) IN (SELECT..) AND (c) IN (SELECT..)`
query changes because the row estimate for the d2ab index is overstated).
