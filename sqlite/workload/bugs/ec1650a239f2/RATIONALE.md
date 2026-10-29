# Rationale

## Change
`tree/src/pragma.c`, `PragTyp_FOREIGN_KEY_CHECK`: removed the line
`zDb = db->aDb[iDb].zDbSName;` after `iDb = sqlite3SchemaToIndex(db, pTab->pSchema);`.

Reverses the fix hunk that added `zDb = db->aDb[iDb].zDbSName;`. Before the fix,
`zDb` was never re-pointed at the child table's schema, so the parent lookups
`sqlite3FindTable(db, pFK->zTo, zDb)` used the pragma's original schema name
(NULL = search all schemas, main first). A child in `aux` referencing `t2` could
therefore resolve to `main.t2`, and its constraints were checked against a table in
another schema. (3.54.1 already uses `iDb` in place of the old `iTabDb`, so only the
`zDb` line needed to go.)

## Oracle failures (test/fkey5.test)
- fkey5-12.0, fkey5-12.1: "database disk image is malformed" (the parent cursor opens
  main.t2's root page in aux's database).
- fkey5-13.0: also fails with "database disk image is malformed".
