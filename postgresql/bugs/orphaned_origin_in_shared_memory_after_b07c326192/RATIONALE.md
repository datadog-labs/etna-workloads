# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b07c326192d09d996afd761a6224bf74273128a1 ("Fix orphaned origin in shared memory after DROP SUBSCRIPTION"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/subscriptioncmds.c, src/backend/replication/logical/tablesync.c

Failing oracle cases:
- `src/test/subscription|t/004_sync.pl|all replication origins have been cleaned up`
