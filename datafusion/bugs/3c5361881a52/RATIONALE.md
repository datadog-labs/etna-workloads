# Rationale

Bug: aggregate `FILTER` results that are NULL were treated as true in the grouped
accumulation helpers, because only the value bits of the filter `BooleanArray` were read.

Change (only `datafusion/functions-aggregate-common/src/aggregate/groups_accumulator/accumulate.rs`):
- `accumulate_multiple`: reverses the hunk that routes the filter through `filter_to_validity`;
  it now uses `filter.values().clone()` (value bits only, null bitmap ignored).
- `accumulate_indices`, `(None, Some(filter))` and `(Some(valids), Some(filter))` arms: reverses the
  `filter_to_validity(filter)` hunks, using `filter.values()` bits again.
- Dropped the now-unneeded `filter_to_validity` import. The helper in `nulls.rs` is kept, since
  `filter_to_nulls` still uses it and it is correct on its own. The fix's `filter_to_nulls` and
  `array_agg` changes were not reverted because they are refactors, not the defect.

Oracle failures (aggregate.slt): `corr(x, y) FILTER (WHERE b < 1)` with GROUP BY returns `0 1`
instead of `0 NULL`, and `COUNT(a) FILTER (WHERE b < 1)` with GROUP BY returns `0 1` instead of `0 0`.
