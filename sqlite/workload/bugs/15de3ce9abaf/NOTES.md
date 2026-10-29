repro.sql: LEFT JOIN whose ON clause is `c IS NULL` where c is a constant column of a subquery (notnull2-4.1).
The IS NULL term is folded to false with prereqAll=0. The buggy shell aborts with assertion
`pT->prereqAll!=0 || !ExprHasProperty(pX, EP_OuterON)` in sqlite3WhereBegin (rc=134); the clean shell prints `3|`.
