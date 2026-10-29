# Rationale

Fix: in RETURNING, a table qualifier that is not the modified table must raise "no such column" instead of being ignored.

In 3.54.1 the check lives in two places; both are reverted to "ignore the qualifier".

1. `src/resolve.c`, lookupName(), trigger/RETURNING branch. This reverses the fix hunk that added
   `zTab==0 || sqlite3StrICmp(zTab,pTriggerTab->zName)==0`. The condition (now also with
   `isValidSchemaTableName` and ALWAYS) is dropped, so any qualifier (new., old., another., t2., alias.)
   resolves to the modified table, which is the pre-fix behaviour.
2. `src/resolve.c`, lookupName(), pSrcList loop. Since the fix, trigger.c (codeReturningTrigger) first runs
   sqlite3SelectPrep() over the RETURNING list against a one-table SrcList to compute column names. That
   pass independently rejects bad qualifiers, so hunk 1 alone has no effect. The qualifier comparison
   (`if( zTab )`) is skipped when `pParse->bReturning && pNC->pNext==0`, i.e. the outermost name context of
   the RETURNING list. Subqueries (pNext!=0) are unaffected. It is the same defect: a wrong qualifier ignored.

## Oracle failures (test/returning1.test)
7.2, 7.3, 7.4, 7.6, 7.7, 7.8 fail (the statements succeed instead of "no such column"). 8.2, 8.3 and 22.1
also fail as collateral. 7.5 is not reported failing.
