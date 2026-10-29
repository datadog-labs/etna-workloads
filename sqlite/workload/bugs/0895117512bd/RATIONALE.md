# Rationale

## Changed: src/trigger.c, codeRowTrigger() (sqlite3VdbeTakeOpArray guard)
Fix hunk: `if( db->mallocFailed==0 )` -> `if( db->mallocFailed==0 && pParse->nErr==0 )`.
In 3.54.1 the guard is `if( pParse->nErr==0 ){ assert(db->mallocFailed==0); ...}`.
I restored the pre-fix condition `if( db->mallocFailed==0 )` (dropping the nErr check
and the assert that only holds with it). A sub-parse error (e.g. "hex literal too big")
now still takes the op array of a half-built program, which trips an assert.

## Oracle failures
triggerG-310 fails: `Assertion aLabel!=0 failed` in resolveP2Values (assert/crash);
the subsequent cases (400, 405, 410) don't run because of the crash.
