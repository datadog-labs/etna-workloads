# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 919c9fa13cd0684b437a88719d670a9bf6dd0dc8 ("Prevent invalidation of newly synced replication slots."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/transam/xlog.c, src/backend/replication/logical/slotsync.c, src/include/access/xlog.h

Failing oracle cases:
- `src/test/recovery|t/046_checkpoint_logical_slot.pl|logical slot is not invalidated`
