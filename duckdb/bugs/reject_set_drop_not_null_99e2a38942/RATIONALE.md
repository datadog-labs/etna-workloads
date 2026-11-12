# Rationale

In today's code the nested-field guard lives in `DuckTableEntry` (src/catalog/catalog_entry/duck_table_entry.cpp), not in the transformer. The transformer now stores the full `column_path`. The fix's four hunks (transform_alter.cpp, TransformAlterColumn) therefore map onto four guards in the catalog. I removed those four guards, so the operations read only `column_path[0]` and apply to the top-level column again.

Hunks, all in duck_table_entry.cpp:
- `SetDefault`: removed the `column_path.size() > 1` throw. This is the fix's SET_DEFAULT hunk.
- `SetNotNull`: removed the throw. This is the SET_NOT_NULL hunk.
- `DropNotNull`: removed the throw. This is the DROP_NOT_NULL hunk.
- `ChangeColumnType`: removed the throw for user-issued ALTER_COLUMN_TYPE with a path longer than 1. This is the ALTER_COLUMN_TYPE hunk.

## Oracle result
```
FAIL     test/sql/alter/struct/alter_nested_struct_field_not_implemented.test
         ...:13 Query unexpectedly succeeded!
         ALTER TABLE test ALTER s.a SET NOT NULL;
1 of 1 oracle units fail
```
