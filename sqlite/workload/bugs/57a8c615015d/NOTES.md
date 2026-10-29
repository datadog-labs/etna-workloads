repro.sql: builds t300 with index (a,b,c) and runs
`SELECT ... WHERE a=0 AND (c=0 OR c=99) ORDER BY c DESC LIMIT 1`.
Clean returns `0|1|99|.`; buggy returns `0|0|0|.` (wrong row). The injection drops the check
that an IN term is actually used by the plan before treating ORDER BY as satisfied.
