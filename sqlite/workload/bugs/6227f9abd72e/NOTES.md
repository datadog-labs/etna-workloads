repro.sql: `SELECT * FROM ((VALUES(1), (0.5 IS true)));`

In a multi-row VALUES, a later row containing `x IS TRUE` was treated as constant
and coded before the IS was rewritten to a TRUTH node. Clean shell prints 1, 1.
Buggy shell prints 1, 0 (wrong result for the second row).
