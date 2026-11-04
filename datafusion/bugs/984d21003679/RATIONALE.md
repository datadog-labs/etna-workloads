# Rationale

Fix: "Pick correct columns in Sort Merge Equijoin" (#18772). The old code in the
null-joined path used the wrong side's column count (`take(right_columns_length)`
where the left count was needed), so equijoins with differing column counts on
each side picked the wrong columns.

In 55.2.0 the `stream.rs` code was rewritten (`materializing_stream.rs`, `filter.rs`),
and the old `null_joined_batch` code no longer exists. The equivalent logic is in
`get_corrected_filter_mask`/the batch correction in
`datafusion/physical-plan/src/joins/sort_merge_join/filter.rs`, where, for rows that
failed the join filter, the buffered-side columns are replaced by nulls.

## Change (filter.rs, `JoinType::Left` arm)

`left_cols = schema.fields().len() - buffered_schema.fields().len()` became
`left_cols = buffered_schema.fields().len()`, i.e. the start offset of the
null-ed side uses the right (buffered) column count where the left count belongs,
the same left/right column-count mix-up the fix corrected. It is only correct
when both sides have equal column counts.

## Oracle

`sort_merge_join.slt` fails on
`SELECT * FROM t1 LEFT JOIN t2 on t1.a = t2.a AND t1.b < t2.b`
(t1 has 2 cols, t2 has 3): row `3 300` yields `3 300 3 NULL NULL` instead of
`3 300 NULL NULL NULL`, since the wrong columns are nulled.
