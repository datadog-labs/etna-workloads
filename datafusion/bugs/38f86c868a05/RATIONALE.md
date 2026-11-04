# Rationale

In 55.2.0 the projection for `generate_series` is no longer applied inside
`GenericSeriesState::generate_next_batch`. `GenerateSeriesTable::scan` calls
`LazyMemoryExec::with_projection`, and `LazyMemoryStream` projects each batch.
The fix's three hunks (pass `projection` to `as_generator`, store it in
`GenericSeriesState`, call `batch.project`) therefore have no direct
equivalent here.

## Change
`datafusion/physical-plan/src/memory.rs`, `LazyMemoryExec::with_projection`:
removed `self.projection = projection;`.

This reverses the fix hunk `batch.project(projection)` in
`GenericSeriesState::generate_next_batch`. That is where the batch was projected
before emission. The exec still advertises the projected schema, but the
generator's batches are no longer projected. This is the pre-fix state: the
declared schema is projected and the emitted batch is full-width.

## Oracle
`table_functions.slt` fails on
`select g1.value from generate_series(1, 3) g1 CROSS JOIN generate_series(1, 3) g2;`
with `Batch has 1 columns but BatchCoalescer expects 0`. The unused side of the
cross join has an empty projection, but it still emits a one-column batch.

Side effect: `LazyMemoryExec` is generic, so any other user of
`with_projection` loses batch projection too. Its own unit test
`test_memory_stream_emitted_batch_matches_declared_schema_with_projection`
would likely fail.
