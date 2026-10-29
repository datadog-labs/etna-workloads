# Rationale

Fix 771fe617: `sqlite3VdbeMemSetStr()` gave blobs (enc==0) the database encoding
instead of UTF8, so function-result blobs cast to text in UTF16 databases were
treated like blobs read from the database.

In 3.54.1 `sqlite3VdbeMemSetStr()` already sets `enc = SQLITE_UTF8` for blobs
(the pre-fix state), and the case is covered by a second path: 
`sqlite3VdbeChangeEncoding()` in src/vdbemem.c, called from `setResultStrOrError()`
on every function result, stamps `pMem->enc = desiredEnc` on non-string values.
I removed that assignment (now it just returns for non-MEM_Str). This is the same
defect: a function-returned blob keeps UTF8 enc in a UTF16 database.
It reverses the fix's `enc==0 -> ENC(db)` hunk (the vdbemem.c hunk), via the equivalent path.
The fix's second sub-hunk (BOM check condition) is not reverted; it is already in its
post-fix form and unrelated to the failure.

## Oracle failures
- test/cast.test cast-8.2: `CAST(X'310032003300' AS TEXT)==CAST(substr(X'310032003300',1) AS TEXT)`
  is no longer 1 in a UTF16 database.
