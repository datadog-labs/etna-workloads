# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 0d8bd0a72ea284ffb1d1154efbe799241cc5edc6 ("Improve logical replication connection-failure messages."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/subscriptioncmds.c, src/backend/replication/logical/slotsync.c, src/backend/replication/logical/tablesync.c, src/backend/replication/logical/worker.c, src/backend/replication/slotfuncs.c, src/backend/replication/walreceiver.c

Failing oracle cases:
- `src/test/regress||subscription`
