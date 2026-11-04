# Rationale

## Hunk changed: `datafusion/physical-plan/src/joins/utils.rs`, `max_distinct_count`, `Precision::Exact(count)` arm

The fix replaced `count - null_count` with a `checked_sub(..).unwrap_or(0)` (clamped to 0). In 55.2.0 the fixed code was
still present verbatim, so I restored the pre-fix code: a bare `count - stats.null_count.get_value().unwrap_or(&0)`.
The Exact/Inexact result selection is unchanged. This is the same computation the fix removed. When `null_count > num_rows`
(for example `num_rows` capped to `Exact(fetch)` by a pushed-down limit, with an uncapped column `null_count`), it
overflows and panics.

## Oracle failure

`joins.slt`: the added query (`SELECT ... FROM (SELECT * FROM t1 ORDER BY b LIMIT 1) sub JOIN t2 ON sub.a = t2.c`) fails
with `attempt to subtract with overflow` at `utils.rs:1058`. This is the panic the fix guards against.
