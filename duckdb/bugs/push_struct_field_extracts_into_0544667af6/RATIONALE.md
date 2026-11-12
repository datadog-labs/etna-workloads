# Rationale

## Hunk
`src/include/duckdb/common/multi_file/multi_file_function.hpp`, `MultiFileScanStats` (statistics section, after merging union readers' stats).

Traces to the fix's single hunk, which merged per-file stats first and then fell through to `PushdownExtract` for both single- and multi-file. I added `return result;` at the end of the `if (result && multiple_files)` block, so the multi-file union_by_name path returns the merged whole-STRUCT statistics and skips `PushdownExtract`. That restores the original behaviour: the optimizer gets STRUCT stats for a pushed-down struct field extract (VARCHAR), giving "Vector::Reference used on vector of different type".

## Oracle result
```
FAIL     test/sql/copy/parquet/union_by_name_struct_extract_stats.test
         test/sql/copy/parquet/union_by_name_struct_extract_stats.test:13 :: Query unexpectedly failed
1 of 1 oracle units fail
```
