# Rationale

Fix hunk reversed: `UnnestExec::compute_properties` (datafusion/physical-plan/src/unnest.rs).
The fix built equivalence properties by projecting the input's properties over the
non-unnested columns (dropping constraints) and projected the output partitioning.
I restored the pre-fix computation: `EquivalenceProperties::new(schema)` (no input
orderings/equivalences preserved) and `input.output_partitioning().to_owned()`.
The signature/`Result` plumbing from the fix is kept, since it is harmless and
callers (planner, proto) still use it; the now-unused projection-mapping code was removed
along with its imports.

Oracle failure: unnest.slt EXPLAIN cases (e.g. line ~1224, the unnest of
nested array/struct/array ordered by column4) now show an extra `SortExec`
above `UnnestExec` because the input ordering on the unrelated column is lost.
