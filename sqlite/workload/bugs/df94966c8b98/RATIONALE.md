# Rationale

Fix hunk (src/build.c, convertToWithoutRowidTable) moved the "bypass PK btree
creation" `OP_Goto` rewrite out of the `else` branch (table with no INTEGER
PRIMARY KEY column) to after the PK index is located/created, guarded by
`pPk->tnum>0`, so it also covers the `iPKey>=0` case.

In tree/src/build.c I reverted that: the `if( v ){ ... OP_Goto }` block is back
in the `else` branch right after `pPk = sqlite3PrimaryKeyIndex(pTab)`, and the
later `if( v && pPk->tnum>0 )` block is removed. For `INTEGER PRIMARY KEY UNIQUE`
WITHOUT ROWID, the freshly created PK index's OP_CreateBtree is no longer
turned into OP_Goto, so an extra btree and sqlite_master entry are created.

Oracle failure: without_rowid1-8.1 hits assertion
`pPk->tnum==pTab->tnum || CORRUPT_DB` in sqlite3OpenTable (crash).
