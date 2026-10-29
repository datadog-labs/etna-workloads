# Rationale

Fix: for an UPDATE in one-pass mode using a partial index that references no
table column (loop has `nLTerm==0`), don't use OP_DeferredSeek, because the
seek may be unresolved when OP_Delete/OP_Insert run.

In 3.54.1 the WHERE_SEEK_TABLE / WHERE_SEEK_UNIQ_TABLE branch is gone; the code
always emits OP_DeferredSeek and update.c emits OP_FinishSeek when
`sqlite3WhereUsesDeferredSeek()` is true. The equivalent of the fix's
`pLoop->nLTerm==0` condition is therefore "the seek is not recorded as deferred".

## Changes
1. `src/wherecode.c` (after `codeDeferredSeek()` in the index-loop code):
   `if( pLoop->nLTerm==0 ) pWInfo->bDeferredSeek = 0;`
   With no constraint terms on the index (the fix's `nLTerm==0` case) the
   deferred seek is not reported, so update.c omits OP_FinishSeek and
   the OP_Delete/OP_Insert run with `deferredMoveto` still pending.
2. `src/where.c` `whereUsablePartialIndex()`: removed the later
   `!sqlite3ExprImpliesExpr(pParse, pExpr, pWhere, -1)` condition. That
   condition (added after the 2019 fix) rejects a partial index whose WHERE
   is implied by a constant term, so such an index (`CREATE INDEX t1x1 ON t1(1)
   WHERE 3`) can no longer be chosen at all and the scenario is unreachable.
   Removing it restores the 2019 planner behaviour so the code path is reachable.
   This is a second, separate revert (reachability only), not part of the fix.

## Oracle
`update-17.10` fails: `Assertion pC->deferredMoveto==0 failed` in
sqlite3VdbeExec (crash/assert, matching the "seek not resolved before OP_Delete").
