# Rationale

Fix hunk (src/build.c, sqlite3CreateIndex): added `if( !pTab ) goto exit_create_index;`
after `pTab = pParse->pNewTable;`. With `CREATE TABLE IF NOT EXISTS` on an existing
table, no pNewTable is created, so the inline UNIQUE/PRIMARY KEY index creation sees a NULL pTab.

Change: removed that same line in tree/src/build.c (the `else` branch of sqlite3CreateIndex, ~line 4113).
The following `pTab->pSchema` dereference now crashes on NULL. No other path covers it.

Oracle: table-2.1e (`CREATE TABLE IF NOT EXISTS test2(x UNIQUE, y TEXT PRIMARY KEY)`)
crashes testfixture (NULL deref), so the run is incomplete and all later cases in table.test fail too.
