# Rationale

Fix hunk reversed: `src/trigger.c` in `sqlite3FinishTrigger()`, the addition of
`sqlite3FixExpr(&sFix, pTrig->pWhen)`. I removed that call, so the trigger's WHEN
clause is no longer walked by the fixer and `?` variables there are neither rejected
at CREATE time ("trigger cannot use variables") nor converted to NULL when the schema
is loaded. This is the pre-fix behaviour.

The other fix hunks (`bVarOnly`, extra clauses in FixSelect, the TK_VARIABLE check in
FixExpr) have no counterpart to revert. The code now uses a Walker (`fixExprCb`,
`fixSelectCb`), which covers them. Only the WHEN clause is still handled separately.

Oracle failures:
- triggerE-1.1.1 and 1.2.1: `CREATE [TEMP] TRIGGER ... WHEN new.a = ?` succeeds instead of
  returning an error. This also cascades into 1.1.2 (`tr1 already exists`).
- triggerE-2.3: assertion `pOp->p1>0 && pOp->p1<=p->nVar` in sqlite3VdbeExec. The
  WHEN `?1` loaded from sqlite_master is not replaced by NULL.
