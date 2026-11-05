# Rationale

## src/backend/commands/policy.c, RemoveRoleFromObjectPolicy()

Traces to the fix.patch hunk that rebuilds the roles array "without any mentions of the target role" and recomputes `num_roles = j`.

The fix copies every entry that differs from the target role and then uses the resulting count, so duplicate polroles entries are all removed. The change here goes back to the old assumption that exactly one entry is removed:
- The copy loop skips only the first matching entry. Later duplicates are copied back in.
- `num_roles` is set to `num_roles - 1` instead of the real count `j`.

With duplicate entries, DROP OWNED BY leaves the dropped role in polroles. It can also keep a policy that should have been dropped, because the count no longer reflects the entries actually removed.

Not reverted: the `CommandCounterIncrement()` and `keep_policy` restructuring. The current code already differs from the pre-fix layout, and those parts aren't needed to bring the bug back.

## Oracle cases expected to fail
- src/test/regress||rowsecurity

Status: confirmed. The oracle run reports `FAIL  src/test/regress||rowsecurity` (1/1 failing).
