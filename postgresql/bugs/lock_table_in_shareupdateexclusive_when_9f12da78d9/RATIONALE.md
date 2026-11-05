# Rationale

File/function: src/backend/statistics/stat_utils.c, RangeVarCallbackForStats().

Traces to the fix.patch hunk in stats_lock_check_privileges(), which made the code lock the
parent table in ShareUpdateExclusive before the index. In the current code that locking lives
in the RangeVarGetRelidExtended callback (the "Lock heap before index" block at its end). I
removed that block, so importing index stats takes only the index's own lock (ShareUpdateExclusive
via the caller) and never locks the parent table. This brings back the bug: the table is not
locked when index stats are imported.

Failing oracle case: src/test/regress||stats_import
