# Rationale

Fix: OP_Found now expands zero-blobs (ExpandBlob) before comparing, so a
zeroblob() and an all-zero blob compare equal (DISTINCT, ticket fccbde530a6583b).

In 3.54.1 OP_Found no longer calls ExpandBlob on the register array; instead
the index-record comparison handles MEM_Zero values itself. That is the
code that now plays the role of the fix's hunk.

## Change
`src/vdbeaux.c`, `sqlite3VdbeRecordCompareWithSkip`, "RHS is a blob" branch:
removed the `else if( pRhs->flags & MEM_Zero )` arm (isAllZero check and
`nStr - pRhs->u.nZero`). An unexpanded zeroblob (n==0, nZero>0) is again
compared as a zero-length blob, so zeroblob(5) != x'0000000000', i.e. the
pre-fix behaviour where OP_Found saw unexpanded zero-blobs.

## Oracle
`distinct-4.1` fails (assertion `vdbeRecordCompareDebug` in
sqlite3VdbeRecordCompareWithSkip, since the debug reference comparison still
treats them as equal; in non-debug builds DISTINCT would return both blobs).
