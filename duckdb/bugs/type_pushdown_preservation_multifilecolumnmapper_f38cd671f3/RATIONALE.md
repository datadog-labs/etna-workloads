# Rationale

File: src/common/multi_file/multi_file_column_mapper.cpp

Two hunks, both removing the `if (global_index.HasType()) { result.column_index->SetType(...); }` block:
1. `MapColumnList` — traces to the fix's first hunk (the type was added after `result.column_index = make_uniq<ColumnIndex>(...)`).
2. `MapColumnMap` — traces to the fix's second hunk.

In today's code the block uses `local_column.type` (the fix text used `global_column.type`). I removed the whole block, which restores the pre-fix behaviour: the list/map ColumnIndex has no type set. The parent struct then asks for the child's scan type and hits an assertion.

## Oracle
```
FAIL     test/parquet/schema_nested_extract.test
         test/parquet/schema_nested_extract.test:33
         SELECT UNNEST(data) FROM mapped;
         INTERNAL Error: Assertion triggered ... column_index.cpp on line 40: HasType()
1 of 1 oracle units fail
```
