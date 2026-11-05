# Rationale

The `relhasoids` code was removed from PostgreSQL, so the original change (`false` -> `relhasoids` in `ExecTypeFromTL`) no longer applies literally. The analogue today is the ON CONFLICT DO UPDATE projection slot: the fix made it match the target table's layout, including system columns such as the oid. It is now created with `table_slot_create`.

## Changed hunk
- File and function: `src/backend/executor/nodeModifyTable.c`, `ExecInitModifyTable`.
- Traces to: the fix.patch hunk in `ExecInitModifyTable` that builds the `mt_conflproj` slot from `ExecTypeFromTL(node->onConflictSet, ...)`.
- Change: `oc_ProjSlot` is now a virtual slot built from `ExecTypeFromTL(node->onConflictSet)`. It no longer comes from `table_slot_create` on the result relation.
- Why it brings the bug back: the projected tuple is built from the bare target list. It has no room for system attributes (the oid in the original bug, now tableoid and the like), so DO UPDATE on such tables or in RETURNING mishandles the tuple.

## Failing oracle case
- `src/test/regress||insert_conflict`
