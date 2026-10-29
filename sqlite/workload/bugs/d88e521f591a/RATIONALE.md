# Rationale

Fix hunk reversed: `src/main.c` `disconnectAllVtab()` — the fix added `sqlite3VtabUnlockList(db)` before `sqlite3BtreeLeaveAll(db)`. I removed that call. Vtabs on `db->pDisconnect` are then never xDisconnect()ed at close, so their internally held prepared statements remain unfinalized.

The rtree.c hunk only added asserts, so I did not revert it.

Oracle cases that fail: `vtab_shared-2.2.1` (fts3 variant: closing the connection fails with an error because of the unfinalized statements held by the un-disconnected vtab), plus unfreed memory is reported.
