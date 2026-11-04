# Rationale

Fix hunk: `like_coercion` in `datafusion/expr-common/src/type_coercion/binary.rs` dropped
`.or_else(|| list_coercion(lhs_type, rhs_type))`, so LIKE on nested types fails coercion.

55.2.0 changed `list_coercion` to take a `coerce_fn` argument, so the old call no longer
compiles as written. I re-added it as `.or_else(|| list_coercion(lhs_type, rhs_type, like_coercion))`
directly after `string_coercion`, which is the original position. I also removed the doc note the
fix added, which says list coercion is intentionally excluded.

## Oracle
`type_coercion.slt` fails. The `LIKE`/`NOT LIKE`/`ILIKE`/`NOT ILIKE` queries on `REGEXP_MATCH(...)`
(a List) are now coerced to List(Utf8View) instead of raising "There isn't a common type to coerce".
They then hit an internal assertion in nested-comparison code
("invalid operator or data type mismatch for nested data, op !~~* ...").
