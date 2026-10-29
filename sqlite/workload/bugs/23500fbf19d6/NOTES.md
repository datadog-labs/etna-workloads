# Reproducer notes

`repro.sql` mirrors bestindexG-2.x. The upstream test uses a Tcl virtual table whose xConnect declares a
`WITHOUT ROWID` table. The shell has no such module, so `zipfile` stands in: its declared schema has a
`PRIMARY KEY`, so `sqlite3_declare_vtab()` calls `sqlite3ReadSchema()` during xConnect.

Sequence: a failed `CREATE VIRTUAL TABLE` and a failed generated-column `CREATE TABLE` reset the schema inside an
exclusive transaction. `PRAGMA quick_check` then connects the fts5 table. That connect leaves a schema reset
pending (`DB_ResetWanted`), because `nSchemaLock>0`. Connecting `zipfile` then sets `DBFLAG_SchemaKnownOk`, and
the retry in `sqlite3LockAndPrepare` calls `sqlite3ResetOneSchema(db,-1)`. Without the fix that reset clears the
schema but leaves the flag set.

- clean: prints `ok` for quick_check, exit status 1 (from the two expected errors).
- buggy: the assertion `(db->mDbFlags & DBFLAG_SchemaKnownOk)==0` in `sqlite3InitOne` fails and the shell aborts
  (exit status -6/SIGABRT).
