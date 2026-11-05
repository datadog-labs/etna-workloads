# Rationale
Reverse of the fix (SLRU writes were lumped into buffers_written and not reported separately in pg_stat_checkpointer).

1. src/backend/access/transam/slru.c, SlruInternalWritePage: fix.patch slru.c hunk. Checkpoint SLRU writes are again counted in `ckpt_bufs_written`, not `ckpt_slru_written` / `PendingCheckpointerStats.slru_written`. The SLRU count is no longer reported consistently.
2. src/backend/catalog/system_views.sql, pg_stat_checkpointer view: fix.patch system_views.sql hunk. The `slru_written` column is removed, so the view definition no longer matches rules.out.

The rest of the fix (the C accessor, pg_proc entry, struct fields, log message) is left in place. It is now unused or reports zero for SLRU.

Failing oracle case: src/test/regress||rules
