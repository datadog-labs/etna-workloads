Reproducer: `select 1 where null between null and 2;` and related BETWEEN queries with NULL bounds (copied from the fix's expr.slt tests), plus a string/int BETWEEN.

The buggy build coerces the high bound against the low bound's type instead of its own. `null between null and 2` fails with "type_coercion ... Cannot automatically convert Int64 to Null". The clean build returns an empty result. The `'b' between 'a' and 5` query also behaves differently (clean errors in simplify_expressions on the cast; buggy returns a row).
