# Rationale

File: src/backend/replication/logical/worker.c

- `slot_modify_data()` (fix.patch: `slot_modify_cstrings` hunks): removed the `srcslot` parameter and the copy of srcslot's values/isnull into the slot. It again calls `slot_getallattrs(slot)` then `ExecClearTuple(slot)`, so unreplaced columns are bogus.
- `apply_handle_update()` (fix.patch: apply_handle_update hunk): reinstated `ExecCopySlot(remoteslot, localslot)` before `slot_modify_data`, the bogus slot management the fix removed.
- `apply_handle_tuple_routing()` (partition update path): same adaptation, since it calls the same function in current code.

Failing oracle cases (19/38):
- CREATE PUBLICATION while "wal_level=minimal"
- check changes skipped after subscription publication change
- check non-replicated table is empty on subscriber#2
- check replicated deletes after alter publication
- check replicated insert after alter publication
- check replicated inserts after subscription publication change
- check replication origin was dropped on subscriber
- check replication slot was dropped on publisher
- check replication slot was dropped on publisher#2
- check subscription relation status was dropped on subscriber
- check subscription was dropped on subscriber
- empty transaction is skipped
- log_statement_stats has not been enabled yet
- log_statement_stats in CONNECTION string had effect on publisher's walsender
- update transmits large column value
- update with non-transmitted large column value
- update works with different column order and subscriber local values
- update works with dropped publisher column
- update works with dropped subscriber column
