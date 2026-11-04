# Rationale

## Changed
`datafusion/datasource/src/file_scan_config/mod.rs`, `FileScanConfig::eq_properties()`:
`self.validated_output_ordering()` -> `self.output_ordering.clone()`.

This reverses the fix hunk that changed `eq_properties()` to call `validated_output_ordering()` instead of
`self.output_ordering.clone()`. The ordering is again trusted blindly, without checking inter-file min/max
statistics within each file group. The other fix hunks (helpers, `get_projected_output_ordering` refactor,
`is_sorted` `<=`) have moved or are unrelated to the bug; `validated_output_ordering` is left in place, now unused.

## Oracle
`sort_pushdown.slt` fails (8 errors): for reversed-order or overlapping files, the SortExec is removed
(plan shows `output_ordering=[id DESC]`), and results come back in the wrong order (e.g. `ORDER BY id DESC` returns 3,2,1,9,8,7).
