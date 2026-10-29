# Rationale

Fix: "rowid"/"_rowid_"/"oid" must not resolve in a WITHOUT ROWID table
(added `HasRowid(pTab)` guards in lookupName). In 3.54.1 the guard is
`VisibleRowid(pTab)` (TF_NoVisibleRowid), in three places in src/resolve.c; I removed them:

1. FROM-clause candidate counting (`if( 0==cnt && VisibleRowid(pTab) )` -> `if( 0==cnt )`):
   reverses the fix's guard on the "perhaps the name is a ROWID" path (cntTab/pMatch tracking).
2. Final "Perhaps the name is a reference to the ROWID" condition: dropped
   `ALWAYS(VisibleRowid(pMatch->pSTab) || isNestedFrom)`; equals the fix's `&& HasRowid(pTab)` hunk.
3. Trigger new./old. path: dropped `&& VisibleRowid(pTab)`, reversing the fix's
   `&& HasRowid(pTab)` on the trigger-column hunk.

The fix's other hunks (variable hoisting, cnt->cntTab) are refactoring/unrelated.

Oracle failures: tableopt-2.1.1, 2.1.2, 2.1.3 — `SELECT rowid/_rowid_/oid, * FROM t1`
on a WITHOUT ROWID table returns rows instead of "no such column".
