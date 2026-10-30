# Rationale

Fix: blocked-client notification moved from the list commands into dbAdd(), so any
path that creates a list (RENAME, MOVE, RESTORE, SORT..STORE) wakes BLPOP waiters.
Pre-fix, only the push commands signalled.

Changes (9.0.7 equivalents of the fix hunks):
- src/db.c dbAddInternal(): `signalKeyAsReady(...)` now skipped for OBJ_LIST
  (reverses the `if (val->type == REDIS_LIST) signalListAsReady(db,key)` added to dbAdd).
- src/t_list.c pushGenericCommand(): explicit `signalKeyAsReady(..., OBJ_LIST)` after
  creating the list (reverses removal of the `may_have_waiting_clients` signal).
- src/t_list.c lmoveHandlePush(): explicit signal after dbAdd (reverses removal of
  `signalListAsReady(c,dstkey)` in rpoplpushHandlePush).

Effect: lists created by RENAME/MOVE/RESTORE/SORT..STORE never wake blocked clients.
Verified manually: `BLPOP foo 2` then `LPUSH bob; RENAME bob foo` -> BLPOP times out
(nil) instead of returning. Oracle cases that should fail: "BLPOP when new key is moved
into place", "BLPOP when result key is created by SORT..STORE" and their BLMPOP_LEFT
variants. Note: the full ./check.sh run exceeded the 10-minute tool limit (blocked
clients with long timeouts), so the full oracle output was not captured.
