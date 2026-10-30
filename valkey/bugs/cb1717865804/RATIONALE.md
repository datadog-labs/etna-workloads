# Rationale

Fix cb17178: the AOFRW done handler wrongly updated fsync metrics, so an fsync was missed
under everysec and WAITAOF could hang.

## Changes (src/aof.c)
1. `backgroundRewriteDoneHandler`: restored the removed lines in the "AOF enabled" block:
   `aof_selected_db = -1`, the fsync-offset update (`aof_fsync_offset = aof_current_size`
   in the fix, now `aof_last_incr_fsync_offset = aof_last_incr_size`, the only offset in 9.0.7),
   and `aof_last_fsync = server.mstime` (was `unixtime`; now ms). Reverses the last hunk of the fix.
2. `flushAppendOnlyFile`, empty-buffer "all data is fsync'd" branch: removed the later
   "update fsynced_reploff_pending just in case" block (added for a module NO_AOF case). With
   change 1 this block falsely acknowledged the unsynced offset and masked the bug (check.sh
   showed 0 failures with change 1 alone). Removing it lets the missed fsync show up.
   This is a judgement call: it covers the same case from another path, but it was added for a
   different problem (modules using RM_Call NO_AOF).

## Oracle
With both changes the WAITAOF "replica copy everysec with AOFRW"/"slow AOFRW"/"everysec->always
with AOFRW" tests are expected to hang in WAITAOF, as in the original bug; check.sh hit its
10 minute limit and was killed (no per-case report). Change 1 alone: 0 of 38 failing.
