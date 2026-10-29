Reproducer: `repro.sql` (rowid table, then a two-row upsert whose first row gets a
fresh rowid and whose second row conflicts on the old maximum rowid).

Bug: `sqlite3BtreeInsert()` moves the cursor to the new cell (`++pCur->ix`) but
(with the injected bug) leaves `BTCF_ValidNKey` set, so `info.nKey` still holds
the previous last rowid (111). The next `OP_NotExists` for key 111 hits the
"already positioned" shortcut in `sqlite3BtreeTableMoveto()` and leaves the
cursor on row 112, and the `DO UPDATE` then modifies the wrong row.

clean : `111|111!` / `112|112`
buggy : `111|111` / `112|112!`   (wrong row updated)

Note: the upstream test (conflict3-12.2) fails in the harness via an assert
(`pC->movetoTarget==iKey` in OP_Delete) that is only active when the harness
sets `sqlite3_test_control(NEVER_CORRUPT,1)`. The shell can't set that, so the
plain REPLACE case only shows up as a wrong result using the upsert variant.
