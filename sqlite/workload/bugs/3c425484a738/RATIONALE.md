# Rationale

Fix: pragma.c verified the wrong schema cookie (`iDb`, the schema named in the
PRAGMA, default main) instead of the schema that owns the table/index.

In 3.54.1 changes to `src/pragma.c`, reversing the fix hunks:
- `PragTyp_TABLE_INFO`: fix replaced `CodeVerifySchema(iDb)` by `iTabDb`. 3.54.1 calls
  `sqlite3CodeVerifyNamedSchema(pParse, zDb)` (a later rewrite); restored `sqlite3CodeVerifySchema(pParse, iDb)`.
- `PragTyp_INDEX_INFO`: removed `iIdxDb`, verify `iDb` again.
- `PragTyp_INDEX_LIST`: removed `iTabDb`, verify `iDb` again.
- `PragTyp_FOREIGN_KEY_LIST`: removed `iTabDb`, verify `iDb` again.
- `foreign_key_check` hunk NOT reverted (code restructured; not needed).

Oracle failures (pragma4): 4.1.6, 4.2.6, 4.3.6, 4.4.6, 4.5.5 — after a table/index in the
attached db is dropped by another connection, the stale schema is not detected (the main
cookie is checked instead of aux's), so the PRAGMA returns stale rows instead of empty.
