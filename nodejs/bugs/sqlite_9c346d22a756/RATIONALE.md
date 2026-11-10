# Rationale

**Bug:** SQL tag store (`sql.get\`\``, `sql.run\`\`` ...) prepare failures threw the generic
"Failed to prepare statement" instead of the SQLite message (e.g. "no such table: ..."),
unlike `db.prepare()`.

**Change (src/node_sqlite.cc, `SQLTagStore::PrepareStatement`):** one hunk, corresponding to the
single hunk of the fix. `THROW_ERR_SQLITE_ERROR(isolate, session->database_.get())` was changed back
to `THROW_ERR_SQLITE_ERROR(isolate, "Failed to prepare statement")`. The `const char*` overload is
used instead of the `Database*` overload that reads `sqlite3_errmsg()`. (Code was refactored since the
fix, so the hunk is re-expressed at the current location.)

**Failing test:** `parallel/test-sqlite-template-tag`, subtest 'sql error messages are descriptive':
`message: 'Failed to prepare statement'` vs expected `/no such column/i` (likewise for `/no such table/i`).
Failure was stable across repeated runs.
