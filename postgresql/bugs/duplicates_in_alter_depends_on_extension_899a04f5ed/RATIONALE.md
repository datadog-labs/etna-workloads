# Rationale

Changed hunk: src/backend/commands/alter.c, ExecAlterObjectDependsStmt (the non-`remove` branch).
It traces to the alter.c hunk in fix_impl.patch, which added the "Avoid duplicates" check. The check called
getAutoExtensionsOfObject() and skipped recordDependencyOn() if the extension was already listed.
I removed the check, so the code again calls recordDependencyOn() unconditionally.
Repeating ALTER ... DEPENDS ON EXTENSION now records duplicate pg_depend entries.
The helper getAutoExtensionsOfObject (the pg_depend.c and dependency.h hunks) is left in place but unused. It is harmless on its own, and the bug is in the caller.

Failing oracle case: src/test/modules/test_extensions||test_extdepend
