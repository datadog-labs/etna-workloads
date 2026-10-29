# Rationale

One change, in `tree/src/prepare.c` (`sqlite3InitOne`): the main-database branch
`if( iDb==0 && (db->mDbFlags & DBFLAG_EncodingFixed)==0 )` is back to `if( iDb==0 )`.

It reverses the fix hunk that added `&& (db->mDbFlags & DBFLAG_EncodingFixed)==0`
to that same condition. Before the fix, reloading the main schema always reset
ENC(db) from the file header. It never checked the encoding against the one
already in use, so an external change (e.g. the backup API) went unnoticed.
Version 3.54.1 still has the EncodingFixed flag, so the flag stays and only
the check that consults it is dropped. The other fix hunks are left alone
because reverting them is not needed to restore the bug.

## Oracle
`enc-12.3` fails. After `db2 backup test.db` replaces the main db with a
UTF-16le one, `SELECT * FROM t2` should report "attached databases must use the
same text encoding as main database". It now silently succeeds with `0 {d e f}`.
