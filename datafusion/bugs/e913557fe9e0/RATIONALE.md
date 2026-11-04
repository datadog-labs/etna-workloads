# Rationale

Fix hunk reversed: `MemorySourceConfig::try_swapping_with_projection` (datafusion/datasource/src/memory.rs).
The fix replaced `MemorySourceConfig::try_new(...)` (which builds a fresh config and resets `fetch` to `None`)
with a clone of `self` that keeps `fetch`. In 55.2.0 the clone-based code was still present, so I restored the
pre-fix body: `try_new(self.partitions(), self.original_schema(), Some(new_projections))`. The projected
schema and sort-info handling is done inside `try_new`, so this is the old code verbatim.

Only the implementation hunk is reverted; the added unit test and slt are untouched.

Oracle: limit.slt fails at the `SELECT col_c, col_b FROM t21176 LIMIT 5` case: all 20 rows are returned
instead of 5, because the pushed-down `fetch` is dropped when the projection is swapped into the source.
