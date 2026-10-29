# Rationale

## Change (src/build.c, convertToWithoutRowidTable)
Reverses the fix hunk that added, in the duplicate-column removal loop of the PRIMARY KEY:

    pPk->azColl[j] = pPk->azColl[i];
    pPk->aSortOrder[j] = pPk->aSortOrder[i];

Without them, when a duplicate column is dropped from e.g. PRIMARY KEY(a,a,b), aiColumn is
compacted but azColl/aSortOrder are not, so the surviving columns keep the collation and sort
order of the wrong (original-position) entries. This is the pre-fix behaviour. The other fix hunks
(nExtra computation, nPk assignment, assert) are already present in 3.54.1 and left untouched.

## Oracle failure
without_rowid7-1.1: `CREATE TABLE t1(a, b COLLATE nocase, PRIMARY KEY(a, a, b))`; b gets the
collation of the stale slot (a's BINARY), so inserting (1,'one'),(1,'ONE') succeeds instead of
raising "UNIQUE constraint failed: t1.a, t1.b".
