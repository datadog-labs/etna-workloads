# Rationale

Changed file: src/backend/access/transam/xlog.c

Hunks: CreateCheckPoint() and CreateRestartPoint(). Both trace to the first two
hunks of fix.patch. The `if (InvalidateObsoleteReplicationSlots(...)) { recompute
_logSegNo from RedoRecPtr; KeepLogSeg(...) }` blocks are removed, so the return
value is ignored. The slot.c and slot.h hunks are left as they are, because the
return value there is harmless on its own.

Why this restores the bug: after slots are invalidated, the old-segment horizon
(_logSegNo) is no longer recalculated. It stays at the value computed while the
slots still held WAL back, so the checkpoint or restartpoint removes fewer old
segments than it should.

Failing oracle case:
- src/test/recovery|t/019_replslot_limit.pl|check that segments have been removed
