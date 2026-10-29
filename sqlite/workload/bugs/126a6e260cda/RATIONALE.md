# Rationale

Fix hunk (src/build.c, sqlite3FinishCoding): `if( v && ALWAYS(pParse->nErr==0) ...` became `if( v && pParse->nErr==0 ...`, because an oversize hex literal in a factored-out constant can set nErr while the constant is coded at the end of the program.

In 3.54.1 the code is restructured: the final check is `if( pParse->nErr==0 ){` (src/build.c ~line 270), and constants are coded just above it (the `pConstExpr` loop). I restored the `ALWAYS()` wrapper there. In debug builds ALWAYS asserts the condition is true, so the legitimate error path now aborts.

Oracle: hexlist-410 (`INSERT INTO t1 VALUES(1+0x10000000000000000)`) fails with `Assertion '0' failed` in sqlite3FinishCoding instead of returning "hex literal too big".
