# Rationale

Bug: fts5 integrity-check fails (reports corruption) on `detail=none` tables with more than one column.

Changed only `tree/ext/fts5/fts5_storage.c` (the index-side `fts5QueryCksum` / `sqlite3Fts5IndexIntegrityCheck` detail=none branches
are left intact; the storage side alone recreates the mismatch between the two checksums):

- `fts5StorageIntegrityCallback`: reverses the fix's `switch(eDetail)` and restores
  `iPos = pTermset ? iCol : szCol-1; iCol = pTermset ? 0 : iCol;`. With detail=none, a termset is
  present, so entries are checksummed as (col 0, pos iCol) rather than (0,0), which the index side no longer matches for columns > 0.
- `sqlite3Fts5StorageIntegrity`: reverses the fix's per-row termset for NONE, restoring a per-column termset
  for `eDetail!=FTS5_DETAIL_FULL` (create and free), as before the fix.
  The trailing free of ctx.pTermset is harmless (null) and left.

Failing oracle cases: fts5simple2-9.2.1 (two-column detail=none integrity-check returns corruption) and fts5simple2-11.4.
