# Rationale

In 3.54.1 the fts5 code (`ext/fts5/fts5_storage.c`) has none of the fix's
hunks (`db_enc`, `fts5EncodingFix`, ...). Instead the same case is covered
in the core: `bindText()` in `src/vdbeapi.c` tags a value bound with
`sqlite3_bind_blob()` with the database encoding
(`if( encoding==0 ) pVar->enc = ENC(p->db);`). Because of that, the blob's
encoding always equals the db encoding when fts5 calls
`sqlite3_value_text()`, so the fix's `sqlite3_value_encoding(pVal)!=db_enc`
check would never fire. The fix's problem statement is that a bound blob is
tagged UTF-8 in a non-UTF-8 database.

## Change
`src/vdbeapi.c`, `bindText()`: the blob is tagged `SQLITE_UTF8` instead of
`ENC(p->db)`. This restores the state the fix's comment describes
("sqlite3_bind_blob() always sets encoding=utf8"). fts5 then tokenizes the
raw blob bytes as UTF-8, while the content read back from the db is
converted from UTF-16, so the index and the content disagree, and the
delete path corrupts the index. This is the pre-fix behavior; the fix's
fts5 hunks are not reproduced because the core change alone brings the bug
back.

## Oracle failures
`fts5ab-{full,col,none}-8.3` fail with "database disk image is malformed"
(the `integrity-check` after inserting a bound blob into a UTF-16le db).
