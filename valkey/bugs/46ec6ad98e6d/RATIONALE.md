# Rationale

Bug: when AOF is enabled after startup (AOF_WAIT_REWRITE), the accumulating INCR file was put
in the manifest immediately, so a restart before the first AOFRW finished loaded it without a base.
The fix used a temp INCR file, renamed and added to the manifest only on AOFRW success.

Changes (all in src/aof.c), reversing fix hunks:
1. `openNewIncrAofForAppend`: removed the `AOF_WAIT_REWRITE` branch using `getTempIncrAofName()`; always
   dup the manifest, take `getNewIncrAofName(temp_am)` and persist the manifest (pre-fix behaviour).
2. `backgroundRewriteDoneHandler`: removed the "Rename the temporary incr aof file" block
   (the incr file is already in the manifest, so no rename is needed).
3. `backgroundRewriteDoneHandler` cleanup: removed the WAIT_REWRITE clearing of aof_buf and
   `aofDelTempIncrAofFile()` (no temp file exists any more).

Other fix parts (consecutive failures counter, feedAppendOnlyFile condition, cron flush) left intact.

Expected oracle failures: "AOF will open a temporary INCR AOF to accumulate data until the first AOFRW
success when AOF is dynamically enabled" (manifest created during WAIT_REWRITE, no "Removing the temp incr
aof file" log), and possibly "AOF enable will create manifest file"-style cases.
