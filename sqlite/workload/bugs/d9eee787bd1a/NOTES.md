CREATE TABLE ... AS SELECT from a VALUES coroutine whose row contains `IN (list)` (needs an extra cursor).
The buggy build hardcodes cursor 1 for the new table, which collides with the cursor used by IN,
so it hits assert(pParse->nTab==1) (crash/abort). The clean shell prints `1|2` and `3|0`.
