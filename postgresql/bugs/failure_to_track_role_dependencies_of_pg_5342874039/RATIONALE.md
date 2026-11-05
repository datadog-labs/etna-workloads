# Rationale

## src/backend/catalog/aclchk.c, recordExtensionInitPrivWorker()
Traces to the fix.patch hunk in recordExtensionInitPrivWorker that, after
CatalogTupleInsert of a new pg_init_privs row, calls updateInitAclDependencies()
("Update pg_shdepend, too."). I removed that block. A newly inserted
pg_init_privs entry therefore records no SHARED_DEPENDENCY_INITACL rows for the
roles in its ACL. DROP ROLE and DROP OWNED then neither see nor clean up the
role's mention in pg_init_privs, which is the original bug.

## Oracle cases failing
- src/test/modules/test_pg_dump||test_pg_dump
