# Rationale

Hunk: src/catalog/catalog_entry/duck_table_entry.cpp, DuckTableEntry::DropNotNull.
Traces to the fix's single hunk, which added a check that throws
CatalogException("column %s is in a primary key") when the column is part of the primary key.
I removed that check (the block using GetPrimaryKey()/GetLogicalIndexes), so
ALTER TABLE ... ALTER COLUMN pk DROP NOT NULL is silently accepted again.

Oracle: test/sql/alter/alter_col/test_drop_not_null_primary_key.test should fail because the
expected statement error no longer occurs. (etna-check results appended below once the build finishes.)

## etna-check result
FAIL     test/sql/alter/alter_col/test_drop_not_null_primary_key.test
         Query unexpectedly succeeded! (test/sql/alter/alter_col/test_drop_not_null_primary_key.test:8)!
         ALTER TABLE pk_col ALTER COLUMN i DROP NOT NULL;
1 of 1 oracle units fail
