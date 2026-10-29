# Ticket #1987: PRAGMA encoding honored after the encoding was fixed

Changed: `tree/src/prepare.c`, `sqlite3InitCallback()`: removed
`db->mDbFlags |= DBFLAG_EncodingFixed;`.

Fix hunk reversed: the fix added `DbClearProperty(db, iDb, DB_Empty)` at the top
of `sqlite3InitCallback` (called for every schema row, including rows parsed by
OP_ParseSchema). That marked the database as non-empty so later
`PRAGMA encoding=...` was ignored. In 3.54.1 the equivalent is
`DBFLAG_EncodingFixed` set in the same place (the only place it is set);
pragma.c checks it. Without it, the pragma changes ENC(db) after the schema holds
rows, so the file header says one encoding and later rows are written in another.

Oracle failures (8): enc2-1.0.3, 1.0.4, 2.0.2, 2.0.4, 3.0.2, 3.0.3 (PRAGMA encoding
changes after content exists), enc2-10.1 (the ticket test: "malformed database
schema" because t2 was stored in UTF8 in a UTF16 db), enc2-11.10 (UTF-16 garbled text).
