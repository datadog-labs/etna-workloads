# Rationale

Fix hunk reversed: `sqlite3ExprForVectorField()` in src/expr.c (the hunk that
added `IN_RENAME_OBJECT && pRet` + `SWAP(Expr,*pRet,*pVector)` before the remap).
In 3.54.1 that logic had been rewritten as: in rename mode, take the
sub-expression out of the vector (`*ppVector = 0`) and return it directly.
I restored the pre-fix behaviour: always `sqlite3ExprDup()` the vector element
and call `sqlite3RenameTokenRemap(pParse, pRet, pVector)`, so the rename-token
map points at a duplicate while the original keeps being referenced (the
sub-selects/columns on the RHS of `SET (a,b)=(...)` in a trigger are no longer
tracked correctly, and OOM paths leak/misbehave).

The alter.c hunk (mallocFailed check in renameWalkWith) is still present in
3.54.1 and was left untouched (it is only a malloc-failure guard).

Oracle: `./check.sh` fails 71 cases in test/altermalloc3.test, namely
altermalloc3-2.1 (the ALTER TABLE RENAME on the trigger from the fix's test)
and many altermalloc3-2.2-* fault-injection cases (oom/ioerr/cantopen/full).
