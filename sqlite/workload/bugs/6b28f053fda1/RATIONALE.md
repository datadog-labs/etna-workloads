# Rationale

Fix (CVS 4041): `sqlite3VdbeMemNulTerminate()` now calls `sqlite3VdbeMemExpandBlob()`
before allocating/copying, so a zeroblob (MEM_Zero, n excludes the zero tail) is
never NUL-terminated while still unexpanded. That is what broke CAST(zeroblob(N) AS ...).

In 3.54.1 `NulTerminate` no longer mallocs; the expansion is covered by two other
callers, so both are reverted to the pre-fix behaviour (no expansion before termination/cast):

1. `src/vdbemem.c` `valueToText()`: removed `if( ExpandBlob(pVal) ) return 0;` before
   `sqlite3VdbeMemNulTerminate()` (the path the fix's hunk protected).
2. `src/vdbe.c` `OP_Cast`: removed `rc = ExpandBlob(pIn1); if( rc ) goto abort_due_to_error;`
   before `sqlite3VdbeMemCast()`, the same defect (CAST on an unexpanded zeroblob).
   Reverting only (1) left all oracle cases passing.

## Oracle result
`zeroblob-5.4` (`CAST(zeroblob(100) AS BLOB)` must equal `zeroblob(100)`) fails: the
cast sees only the unexpanded `n` bytes, so the result is wrong. The other cases pass.
