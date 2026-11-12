# Rationale

Hunk: src/storage/table/column_data.cpp, `ColumnData::Select` (the per-segment loop that calls
`current.FetchRow` when `force_fetch_row` is set; the code was restructured since the fix, so the
`SelectVector` function named in the fix no longer exists in that form).

Fix hunk: FetchRow row index changed from `state.offset_in_column + source_idx` (not segment-relative) to a
position relative to the segment start. Today's code computes
`state.offset_in_column + sel_idx - current_start`; I removed `- current_start`, so the row id is column-absolute
rather than segment-relative and goes out of range for any segment after the first.

Oracle result:
```
FAIL     test/sql/storage/compression/rle/rle_select_force_fetch_row.test
         test/sql/storage/compression/rle/rle_select_force_fetch_row.test:28
         INTERNAL Error: ColumnSegment::FetchRow - row_id out of range for segment
1 of 1 oracle units fail
```
