# Rationale

File: src/backend/commands/tablecmds.c, function ExecuteTruncate().
Traces to the fix.patch hunk in ExecuteTruncate that replaced `heap_openrv(rv, AccessExclusiveLock)` + `truncate_check_rel(rel)` with `RangeVarGetRelidExtended(..., RangeVarCallbackForTruncate)`.

The change reverts to `table_openrv(rv, AccessExclusiveLock)` first, then runs truncate_check_rel / truncate_check_perms / truncate_check_activity afterwards. The AccessExclusiveLock is therefore requested before permission checks, so an unprivileged TRUNCATE queues in the lock queue and blocks other queries. The "TRUNCATE foo, foo" duplicate path closes with the lock again, as before the fix.

Failing oracle case: src/test/isolation||truncate-conflict
