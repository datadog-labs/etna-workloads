# Rationale (ticket #1605: BLOB not cast to string before text-wanting functions)

The fix's only implementation hunk added to `sqlite3ValueText()`:
`pVal->flags |= (pVal->flags & MEM_Blob)>>3;` (mark a BLOB as also a string, so it is
re-encoded to the requested encoding). In 3.54.1 that logic lives in two places; both were reverted.

1. `valueToText()` in src/vdbemem.c (called by `sqlite3ValueText`): the unconditional
   `pVal->flags |= MEM_Str` for Blob|Str values, and the encoding change, now happens only when
   MEM_Str is already set. A pure BLOB is no longer treated as a string, so it is not re-encoded
   (pre-fix behaviour; e.g. `blob LIKE 'abc%'` in a UTF-16 database).
2. `sqlite3VdbeMemCast()`, `SQLITE_AFF_TEXT` case: removed the same
   `flags |= (flags&MEM_Blob)>>3` line (and its asserts). This is the same defect: the cast to TEXT
   path was also fixed by marking the blob as a string. Without it CAST(blob AS text) leaves a pure blob.

## Oracle
enc3-2.2 fails (assertion `memIsValid(pCtx->argv[i])` in sqlite3VdbeExec, crashing the run), so
enc3-2.3, 2.4, 3.1, 3.2 are reported failing as the run is incomplete. enc3-2.x are the cases for this fix
(CAST/LIKE of a UTF-16 blob).
