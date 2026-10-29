# Rationale

Fix: assert()s in sqlite3AddReturning() wrongly fired when an `IF NOT EXISTS` trigger that already exists contained 2+ RETURNING clauses. The fix added `Parse.ifNotExists` (debug only), set it in sqlite3BeginTrigger(), and relaxed the asserts. I reverted all of it.

- src/build.c `sqlite3AddReturning`: `assert( pParse->bReturning==0 )` restored (reverses the `|| pParse->ifNotExists` hunk). The second assert (HashFind ... `|| pParse->nErr`) also had `|| pParse->ifNotExists` removed (reverses the second build.c hunk; in 3.54.1 it uses `pRet->zName`).
- src/trigger.c `sqlite3BeginTrigger`: removed `VVA_ONLY( pParse->ifNotExists = 1; )`.
- src/sqliteInt.h: removed `Parse.ifNotExists` field.

Oracle: returning1-19.1 aborts with `Assertion 'pParse->bReturning==0' failed` in sqlite3AddReturning (second RETURNING in an already-existing IF NOT EXISTS trigger). Subsequent cases in the file don't run because of the abort.
