# Rationale

Two hunks of the fix were undone.

1. `src/execution/operator/join/outer_join_marker.cpp`, `OuterJoinMarker::Scan` (fix hunk: per-column slice loop -> `result.Slice(scan_chunk, match_sel, count, left_column_count)`).
   Restored the per-column loop. With zero right-side columns the loop never runs, so the result chunk's cardinality is never set and unmatched build rows are lost.
2. `src/planner/sql_export/sql_export_values.cpp`, `LogicalColumnDataGet::ToSQL` (fix hunk: emit a `NULL` placeholder tuple for zero-column chunks).
   Removed it, so each row exports as an empty VALUES tuple, which is invalid SQL (parser error).

Not reverted: the `EnsureSQLProjection` and UNION-arm hunks. The two hunks above are enough to fail all three oracle units.

## etna-check
```
FAIL test/sql/join/full_outer/test_zero_column_materialized_join.test:15  3 <> 5
FAIL test/sql/sql_export/explain_sql_roundtrip.test:88  Parser Error: syntax error at or near ")"
FAIL test/sql/sql_export/zero_column_relations.test:20  Parser Error: syntax error at or near ")"
3 of 3 oracle units fail
```
