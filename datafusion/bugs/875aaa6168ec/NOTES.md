repro.sql builds a column carrying field metadata (`with_metadata(column1, 'k', 'v')`), casts it to INT in a
subquery, then reads the metadata back with `arrow_metadata`.
Clean: a type-only CAST keeps the source field metadata, so both queries print `v`.
Buggy: the physical CastExpr drops the metadata, so both queries print `NULL`.
(The `now()` nullability half of injection.patch needs Rust-defined table metadata and was not reproduced.)
