# Rationale

Fix hunk: `whereScanInit()` in src/where.c changed `if( iColumn==iPKey )` to
`... && j>0`. The fix's own message calls this "the wrong fix": the real bug
(ticket 16c9801ceba) is that, with an index on the IPK, an OR-clause DELETE
reaches OP_Delete with the OP_DeferredSeek (then OP_Seek) unresolved.

In 3.54.1 the `whereScanInit()` code already has the pre-fix form (IPK column
always mapped to XN_ROWID, no `j>0`), so nothing to revert there. The crash
is instead prevented by the later, proper mechanism: in src/wherecode.c, the
OR-subclause loop propagates `pWInfo->bDeferredSeek = 1` from the sub-WhereInfo
so that delete.c/update.c emit OP_FinishSeek before OP_Delete.

Change: removed that propagation (the 3-line `if( sqlite3WhereUsesDeferredSeek(pSubWInfo) )
pWInfo->bDeferredSeek = 1;` block in wherecode.c). This is the same defect:
the deferred seek is not resolved before OP_Delete.

Oracle failure: test/intpkey.test intpkey-17.0 (the case the fix added) aborts
with `Assertion pC->deferredMoveto==0 failed` in sqlite3VdbeExec.
