# Rationale

File: src/backend/parser/gram.y, rule `DROP INDEX CONCURRENTLY IF_P EXISTS any_name_list opt_drop_behavior` (DropStmt).
Traces to the fix.patch gram.y hunk. The fix set `missing_ok = true` there; I changed it back to `false`.
With it false, `DROP INDEX CONCURRENTLY IF EXISTS nonexistent` raises an error instead of emitting a notice.

Failing oracle case: src/test/regress||create_index
