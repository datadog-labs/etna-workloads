# Rationale

Fix hunk (src/trigger.c, codeRowTrigger): added `pPrg->oldmask = 0xffffffff;` so
the TriggerPrg's old-column mask is pessimistically "all columns" until the
sub-program has finished coding (needed for recursive/cascading triggers that
look up the in-progress TriggerPrg).

In 3.54.1 the field is `pPrg->aColmask[0]` (old.*), initialised alongside
`aColmask[1]` (new.*, added later). I removed only the `aColmask[0] = 0xffffffff;`
line in codeRowTrigger (src/trigger.c), so the TriggerPrg is zeroed (by
sqlite3DbMallocZero) and the old mask is 0 while the trigger is being coded,
exactly as before the fix. `aColmask[1]` was not part of the fix and is untouched.

## Oracle failures
triggerC-9.2 (the test added by the fix): the recursive DELETE trigger finds
its own in-progress program with oldmask 0, so old.* columns are not loaded
for the cascade; the run aborts with
`Assertion memIsValid(&aMem[pOp->p1]) failed` in sqlite3VdbeExec.
