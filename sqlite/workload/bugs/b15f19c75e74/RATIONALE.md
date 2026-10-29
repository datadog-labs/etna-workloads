# Rationale

Fix: fts5 interleaved read/write in one transaction. `sqlite3Fts5HashQuery()` must
not finalize the poslist-size field of the live hash entry; it copies the doclist
into a new buffer and finalizes only the copy (`fts5HashAddPoslistSize(..., pFaux)`).

## Changed hunk (ext/fts5/fts5_hash.c, sqlite3Fts5HashQuery)
Reverses the hunk that passed `pFaux` (the copy) to `fts5HashAddPoslistSize`.
Now the call is `fts5HashAddPoslistSize(pHash, p, 0)`, finalizing the real entry as
before the fix (iSzPoslist/bDel/bContent cleared, nData updated). The doclist is then
copied from the finalized entry. The copy is kept because the rest of the
fix (nPre/ppOut API, fts5SegIterHashInit) is still in place, and the pre-fix code
also used the hash entry's finalized contents. Buffer size is computed from the
pre-finalize nData (+10 slack covers growth).

## Oracle failure
fts5aa-full-24.2 (the new test 24 in fts5aa: DELETE; SELECT; INSERT in one
transaction, then integrity-check): the entry was finalized by the SELECT, so the
later INSERT appends to a closed poslist, corrupting the index; integrity-check
hits `Assertion nChunk>=0` in fts5PoslistCallback.
