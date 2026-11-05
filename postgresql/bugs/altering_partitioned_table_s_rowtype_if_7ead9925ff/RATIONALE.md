# Rationale
- File/function: src/backend/commands/tablecmds.c, ATPrepAlterColumnType (the early find_composite_type_dependencies check).
- Traces to the single fix_impl.patch hunk, which changed the condition from "composite type or foreign table" to `!RELKIND_HAS_STORAGE`.
- Reverted the condition to `relkind == RELKIND_COMPOSITE_TYPE || RELKIND_FOREIGN_TABLE` (keeping the newer virtual-generated-column clause). Partitioned tables have no storage, so they never get the rowtype-dependency check. ALTER COLUMN TYPE on a partitioned table whose rowtype is used elsewhere is then allowed.

Failing oracle case: src/test/regress||alter_table
