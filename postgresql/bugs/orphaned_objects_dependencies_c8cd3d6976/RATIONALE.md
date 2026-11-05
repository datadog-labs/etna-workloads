# Rationale

File: src/backend/catalog/pg_depend.c

1. `recordMultipleDependencies()`: removed the call to `dependencyLockAndCheckObject()` for each non-pinned referenced object (fix.patch hunk adding that call). Without it, the referenced object is not locked or checked for concurrent drop, so dependencies on orphaned/dropped objects can be recorded.
2. `changeDependencyFor()`: removed the `if (!newIsPinned) dependencyLockAndCheckObject(...)` call (corresponding fix hunk). Same effect when changing a dependency's referenced object.

The helper function itself and includes are left in place (unused static, harmless).

Failing oracle cases: src/test/isolation||ddl-dependency-locking, src/test/regress||alter_table
