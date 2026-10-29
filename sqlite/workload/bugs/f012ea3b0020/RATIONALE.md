# Rationale

Fix (ticket #1824): the fix moved the UTF8 default of the schema encoding into
`sqlite3SchemaGet()` (only on first creation of the Schema, `file_format==0`)
and removed the unconditional `ENC(db) = SQLITE_UTF8` in `openDatabase()`,
which overwrote the encoding of an already-shared schema.

Changes in tree/:
- `src/callback.c` `sqlite3SchemaGet`: removed `p->enc = SQLITE_UTF8;`
  (reverses the added line in callback.c).
- `src/main.c` `openDatabase`: added back an unconditional
  `SCHEMA_ENC(db) = SQLITE_UTF8;` after `sqlite3SchemaGet` for the main db
  (reverses the removed hunk; in 3.54.1 the encoding lives in the schema,
  `SCHEMA_ENC`, and `ENC(db)` is set from it via `sqlite3SetTextEncoding`).
  With a shared cache, opening a second connection resets the shared schema's
  encoding to UTF8 although the database is UTF16.

Oracle: shared3-1.2 fails (second shared-cache connection to a UTF16 database
returns `{}` instead of `{This is a test string}`). Other cases pass.
