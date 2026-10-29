# Rationale

Fix (dan, 2013-05-15, [0fc59f908b]): in sqlite3CreateIndex(), an explicit COLLATE
on an index column was stored by its TK_COLLATE token instead of by looking up
the CollSeq. The pre-fix code called sqlite3ExprCollSeq(); when loading a schema
whose collation is unregistered that returns NULL, so the index silently fell
back to the column default / BINARY.

In 3.54.1 the code already uses the token (src/build.c, sqlite3CreateIndex), so I
restored the pre-fix lookup in both places the fix touched:

1. nExtra size loop: for a TK_COLLATE expr, size is added only if
   `sqlite3ExprCollSeq()` returns non-NULL (reverses hunk 1).
2. Per-column loop: the explicit collation branch is taken only when
   `sqlite3ExprCollSeq()` returns non-NULL, using `pColl->zName`; otherwise it
   falls to the column's default collation / BINARY (reverses hunks 2-3). A
   `CollSeq *pColl` local was re-added (reverses the removed declaration).

Both sites stay consistent so the nExtra assert holds. Kept the `op==TK_COLLATE`
guard so only explicit COLLATE clauses are affected.

## Oracle failures (test/collate3.test)
collate3-1.7.2, 1.7.3, 1.7.4, 4.7, 4.8.3, 4.9, 4.10, 4.11: an index with an
unavailable collation is loaded as BINARY, so the expected "no such collation
sequence" error is not raised (or a malformed-schema error appears instead).
