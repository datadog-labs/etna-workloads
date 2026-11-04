# Rationale

Fix hunk reversed: `generate_series.rs` `GenerateSeriesTable::scan` — the fix made `scan` honor `projection` (it had been `_projection`, ignored, with the full schema returned).

In 55.2.0 the projection is passed via `LazyMemoryExec::with_projection(projection.cloned())`. I reverted that to `_projection` / `.with_projection(None)`, so scan again ignores the projection and emits the full schema. This is the same defect as the pre-fix code.

Oracle failure: `aggregate.slt` fails on
`with test AS (SELECT i as c1, i+1 as c2 FROM generate_series(1,10) t(i)) select count(*) from test WHERE 1 = 1;`
with "Internal error: Physical input schema should be the same as the one converted from logical input schema ... (physical) 1 vs (logical) 0".
