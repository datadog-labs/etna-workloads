# Rationale

## src/update.c (sqlite3Update, ephemeral table for UPDATE...FROM)
Reverses the src/update.c hunk of the fix. The fix replaced
`if( pPk ) sqlite3VdbeSetP4KeyInfo(pParse, pPk);` with code that builds the
KeyInfo and sets `pKeyInfo->nAllField = nEphCol`, so the ephemeral index
covers all columns (PK + FROM-clause values). I restored the original call,
so nAllField is only the index's own column count and records written to the
ephemeral table with more fields than that violate the KeyInfo.

The resolve.c hunk (making TK_ROW unconditional) is already unconditional in
3.54.1 and is not reverted; it is a separate build-config issue.

## Oracle failures
test/upfrom3.test fails from upfrom3-2.1.4 on (the WITHOUT ROWID cases that
update primary key columns with UPDATE...FROM): assertion
`nField <= pKeyInfo->nAllField` in vdbeAssertFieldCountWithinLimits aborts
the run, so the remaining cases (3.x, 4.x) also fail.
