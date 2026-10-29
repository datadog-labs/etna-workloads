# Rationale

## src/memdb.c, sqlite3_deserialize()
Reverses the src/memdb.c hunk of the fix. The check that rejects deserializing
into TEMP (`testcase( iDb==1 ); if( iDb<2 && iDb!=0 )`) is replaced with the
pre-fix `if( iDb<0 )`, which only rejects unknown schema names. TEMP (iDb==1)
is accepted again, so sqlite3_deserialize() attaches over the TEMP schema.
(The sqlite.h.in doc hunk is documentation and was not reverted.)

## Oracle failures
memdb1-650: `db deserialize temp [db serialize main]` returns 0 instead of
an error (expected `1 err`), followed by an assertion failure in
sqlite3StatusDown (`N>=0`) in the testfixture.
