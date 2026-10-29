# Rationale

Fix hunk reversed: the `saveAllCursors` change in src/btree.c, which added an
`else` branch so that cursors not in CURSOR_VALID state call
`btreeReleaseAllCursorPages()` before an insert or update.

In 3.54.1 that logic lives in `saveCursorsOnList()`. I removed its `else`
branch (`testcase(...); btreeReleaseAllCursorPages(p);`). Invalid cursors
(for example, ones whose table was emptied by a trigger's DELETE) now keep
references to database pages across later inserts and updates. This is the
pre-fix behaviour. The helper `btreeReleaseAllCursorPages` still exists, and
other callers use it. The first hunk of the fix, which factored out that
helper, therefore needs no revert.

Oracle: `tkt-6bfb98dfc0.100` fails with "database disk image is malformed".
The fix's ticket describes the same symptom, a spurious SQLITE_CORRUPT on the
final INSERT.
