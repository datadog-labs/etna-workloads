# Rationale

## Hunk: src/catalog/catalog_entry/duck_schema_entry.cpp, DuckSchemaEntry::AddEntryInternal
In the CREATE OR REPLACE branch, the call `DropEntryInternal(transaction, *old_entry, entry_name, false, entry->internal)`
is replaced by `OnDropEntry(...)` + `set.DropEntry(...)`. This maps to the fix's added hunk, which put the
FindForeignKeyInformation(AFT_DELETE)/Alter(fk_info) loop after those two calls. In today's code that cleanup is
done inside DropEntryInternal, so bypassing it with the raw two calls and no FK cleanup restores the old behaviour:
a replaced table leaves stale FK references in the referenced (main key) table.

## Oracle result
```
FAIL     test/sql/constraints/foreignkey/test_fk_create_or_replace.test
         test/sql/constraints/foreignkey/test_fk_create_or_replace.test:15
         Query failed, but error message did not match expected error message: <REGEX>:Catalog Error.*table is main key table of the table.*
         CREATE OR REPLACE TABLE parent (id INTEGER PRIMARY KEY);
         Actual result:
         Dependency Error: Cannot drop entry "parent" because there are entries that depend on it.
1 of 1 oracle units fail
```
