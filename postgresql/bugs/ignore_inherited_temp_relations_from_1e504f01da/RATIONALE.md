# Rationale

File: src/backend/commands/tablecmds.c, function ExecuteTruncate.
Traces to the fix.patch hunk that adds the `RELATION_IS_OTHER_TEMP(rel)` check in the inheritance-children loop. The lockmode refactoring hunks are cosmetic and were not reverted.
I removed the check (and its comment). Other sessions' temp child tables are no longer skipped silently. They reach truncate_check_rel/truncate_check_activity, which error out, so TRUNCATE on a parent fails.

Failing oracle case: src/test/isolation||inherit-temp
