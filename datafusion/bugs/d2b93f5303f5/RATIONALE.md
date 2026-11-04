# Rationale

In 55.2.0 `Interval::and` / `Interval::or` (datafusion/expr-common/src/interval_arithmetic.rs)
already had a catch-all arm, returning `TRUE_OR_FALSE` (the same interval as the
fix's `UNCERTAIN`), so the fix's hunks could not be reversed textually.

## Changes
- `Interval::and`: the fallback arm `_ => Ok(Self::TRUE_OR_FALSE)` is back to
  `_ => internal_err!("Incompatible data types for logical conjunction")`
  (reverses fix hunk 1).
- `Interval::or`: same, with `"... logical disjunction"` (reverses fix hunk 2).

When a boolean interval has NULL bounds (e.g. from `CASE` without `ELSE`), the
interval arithmetic errors. The ordering-equivalence code then deems the CASE
ordering unordered, and `SortPreservingMergeExec` fails its sanity check.

## Oracle
`union.slt` fails at its second query (line 1040, the 4-row variant with 'm'):
"does not satisfy order requirements: [CASE WHEN typtype ... END ASC NULLS LAST]".
