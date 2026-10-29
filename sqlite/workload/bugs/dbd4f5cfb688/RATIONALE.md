# Rationale

Bug: an invalidated incrblob cursor (eState=CURSOR_INVALID) keeps its btree page
references, so later btree code sees extra references and reports corruption.

The fix reordered `invalidateIncrblobCursors()` to run *after* `saveAllCursors()`
in three places, so that the still-valid incrblob cursor was saved (releasing its
pages) before being invalidated. Reversed in `tree/src/btree.c`:

- `sqlite3BtreeInsert`: invalidate call moved back before the `saveAllCursors` block
  (reverses fix hunk 1).
- `sqlite3BtreeDelete`: invalidate call moved back before `saveAllCursors`
  (reverses hunk 2).
- `sqlite3BtreeClearTable`: invalidate call moved back before `saveAllCursors`
  (reverses hunk 3).

Second path: in 3.54.1 `saveCursorsOnList()` has an `else` branch that calls
`btreeReleaseAllCursorPages()` for non-valid cursors, which independently covers the
case (the bug was effectively fixed twice). With only the reordering, no oracle case
failed, so that `else` branch was removed too. It's the same defect: invalidated
cursors keep their page references.

Failing oracle cases: incrblob4-1.3, 2.3, 3.3 fail with
"database disk image is malformed" (the corruption false-positive the fix describes).
