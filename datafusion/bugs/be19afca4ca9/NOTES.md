Uses `with_metadata` to attach field metadata (`k=v`) to a column, then casts it.
Clean: `count(DISTINCT n)` grouped by `m::text` works, and `arrow_metadata(m::bigint,'k')` returns `v`.
Buggy: the group-by query fails with an internal error (physical input schema field metadata `{"k":"v"}` vs logical `{}`), and in the cast query the metadata is NULL (cast drops source metadata).
