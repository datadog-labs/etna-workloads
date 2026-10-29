# Rationale

Fix (CVS 6329, #3688): temp triggers on non-temp tables were no longer linked
into `Table.pTrigger`; `sqlite3TriggerList()` finds them on demand in the temp
schema. In 3.54.1 that design is still present, so the bug is restored by
undoing the "do not link" part in `src/trigger.c`:

1. `sqlite3FinishTrigger`: reverses the fix's
   `else if( pLink->pSchema==pLink->pTabSchema )` guard, so the trigger is
   again linked into `pTab->pTrigger` unconditionally. This includes TEMP
   triggers on main/attached tables, which end up on the shared-cache table's list.
2. `sqlite3UnlinkAndDeleteTrigger`: reverses the fix's
   `if( pTrigger->pSchema==pTrigger->pTabSchema )` guard, so the unlink always
   walks `pTab->pTrigger` (matches the old unconditional unlink; NULL-safe).
3. `sqlite3TriggerList`: reverses the fix's on-demand temp-schema search
   (`pTrig->pTabSchema!=pTmpSchema || bReturning` becomes `bReturning`),
   because temp triggers are already on `pTab->pTrigger`. Without this the
   list would become cyclic. RETURNING triggers still use the on-demand path.

## Oracle failures
`test/temptrigger.test`: 1.1-1.2.2 pass, then 1.2.3 hits
`Assertion p->pSchema==p->pTabSchema || p->pSchema==db->aDb[1].pSchema` in
`sqlite3CodeRowTrigger`. A second shared-cache connection sees the first
connection's temp trigger on the shared table. This is the shared-cache
problem the test describes, and the run aborts. 58 of 61 oracle cases fail
(the rest never run).
