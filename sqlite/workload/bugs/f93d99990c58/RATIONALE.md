# Rationale

Fix (ticket #3055) removed the `col_mask` argument of `sqlite3MaterializeView()`
and the `sqlite3SelectMask()` call, which replaced view columns not referenced
by the trigger with NULL in the ephemeral table. Columns referenced only by the
UPDATE's SET expressions (e.g. `yy` in `UPDATE vx SET y = yy`) then read as NULL.

In 3.54.1 that machinery is gone, so it is re-expressed:
- `src/delete.c` `sqlite3MaterializeView`: new `colMask` argument (reverses the
  removed parameter); when not all-ones it builds an explicit result list with
  `NULL` for columns outside the mask (equivalent of `sqlite3SelectMask`).
  DELETE caller passes the OLD.* trigger column mask (reverses the delete.c call hunk).
- `src/update.c`: caller passes old|new trigger masks (reverses the update.c hunk).
- `src/sqliteInt.h`: prototype updated; `TRIGGER_INSTEAD` flag added.
- `src/trigger.c` `sqlite3TriggerColmask`: its early `return 0xffffffff` for views
  is bypassed only when the caller passes `TRIGGER_INSTEAD`, so existing callers
  are unchanged and only the materialize path gets a real mask.

Oracle: `triggerB-1.2` fails (`UPDATE vx SET y = yy` writes NULL into the NOT NULL
column / wrong result because `yy` is read as NULL). Only that case fails.
