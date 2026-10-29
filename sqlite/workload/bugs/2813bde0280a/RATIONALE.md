# Rationale

## src/where.c, whereLoopAddBtreeIndex (WO_EQ|WO_IS branch)
Reverses the fix hunk in `whereLoopAddBtreeIndex`, which changed the test from
`!IsUniqueIndex(pProbe)` to `pProbe->uniqNotNull==0` when deciding between
WHERE_UNQ_WANTED and WHERE_ONEROW. In 3.54.1 the condition was
`iCol==XN_ROWID || pProbe->uniqNotNull || (nKeyCol==1 && onError && (eOp&WO_EQ))`;
I restored the pre-fix form `iCol==XN_ROWID || IsUniqueIndex(pProbe)`, so any
UNIQUE index is assumed to yield one row even if its columns may be NULL
(NULLs are distinct in UNIQUE indexes, so several rows can match `b IS NULL`).
The single-column special case is subsumed by IsUniqueIndex.

## Oracle failure
null-9.3 (`SELECT * FROM t5 WHERE a IS NULL AND b = 'x'` on UNIQUE(a,b)) returns
one row (`{} x two`) instead of two, as the loop stops after the "one row" match.
