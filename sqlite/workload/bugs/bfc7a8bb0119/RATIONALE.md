# Rationale

Fix hunk (src/btree.c, sqlite3BtreeDelete): the `bPreserve` block (decide between
`saveCursorKey()` and CURSOR_SKIPNEXT) was moved to *before* the cursor is moved
to the predecessor entry (`sqlite3BtreePrevious`) when the cell is on an internal page.

Change in tree/src/btree.c: the equivalent block (`if( bPreserve ){ ... saveCursorKey ... }`,
which in 3.54.1 sets `bPreserve = 2` rather than `bSkipnext = 1`) is moved from before
`if( !pPage->leaf ){ sqlite3BtreePrevious() }` to after the incrblob invalidation, just
before the page is made writable. Code is otherwise unchanged. This restores the pre-fix
order: for a non-leaf cell, the cursor has already moved to the predecessor leaf entry when
`saveCursorKey()` runs, so the saved key is the predecessor's rather than the deleted row's.
After the rebalance the cursor is re-seeked to the wrong key, so with
`reverse_unordered_selects` the DELETE loop skips/repeats rows and leaves some undeleted.

## Oracle failure
`delete4-5.0` fails (rows with b=2 remain after `DELETE FROM t1 WHERE b=2`). All other cases pass.
