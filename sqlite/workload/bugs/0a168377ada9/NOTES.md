`repro.sql` runs `SELECT * FROM xy LEFT JOIN ab ON 0` (from join5-2.1).
Clean shell returns the two left rows padded with NULLs. The buggy shell
(OuterON terms no longer add the join's mask to prereqAll) hits the assertion
`pT->prereqAll!=0 || !ExprHasProperty(pX, EP_OuterON)` in sqlite3WhereBegin and aborts.
