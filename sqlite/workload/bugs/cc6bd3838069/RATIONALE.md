# Rationale

The fix stopped INSERT and DELETE from emitting the count_changes result row
when code is generated for a trigger body (`!pParse->trigStack`). In 3.54.1 the
equivalent condition is `!pParse->pTriggerTab`, in the "initialize row counter"
blocks.

- `src/delete.c` (sqlite3DeleteFrom): removed `&& !pParse->pTriggerTab` from the
  `SQLITE_CountRows` condition. Reverses the delete.c hunk.
- `src/insert.c` (sqlite3Insert): removed `&& !pParse->pTriggerTab` likewise.
  Reverses the insert.c hunk.

(UPDATE has no count-changes row-count code in 3.54.1 that was part of the fix.)

Trigger bodies now emit their own "rows inserted/deleted" result rows, so extra
rows are returned.

Oracle failures: pragma-10.1 (INSERT with triggers) and pragma-10.3 (DELETE
with triggers) return extra counts instead of `1`.
