# Rationale

1. src/backend/catalog/index.c, index_check_primary_key(): removed the `if (indexInfo->ii_NullsNotDistinct) ereport(ERROR, "primary keys cannot use NULLS NOT DISTINCT indexes")` block (fix.patch hunk 1). Without it, ALTER TABLE ... ADD PRIMARY KEY USING INDEX accepts a NULLS NOT DISTINCT index.
2. src/bin/pg_dump/pg_dump.c, dumpConstraint(): restored the unconditional `if (indxinfo->indnullsnotdistinct)` (fix.patch hunk 2), so pg_dump emits NULLS NOT DISTINCT for PRIMARY KEY again.

Failing oracle case: src/test/regress||create_index
