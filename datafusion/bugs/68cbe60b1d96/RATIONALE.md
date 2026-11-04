# Rationale

Changed `datafusion/functions-nested/src/map.rs`, `make_map_batch`:
`let expand_scalar = !can_evaluate_to_const;` became `let expand_scalar = false;`.

Fix hunk reversed: the fix added `expand_if_scalar` and expanded scalar keys/values to
`number_rows` whenever the inputs were not both scalar. In 55.2.0 that logic lives in
`into_array_and_type` through the `expand_scalar` flag. Forcing the flag to false restores
the pre-fix path, where a scalar argument goes through `get_first_array_ref` and keeps its
own length N, not the batch size. That is the defect from the fix.

Oracle failure: `map.slt`, `SELECT map(['a','b'], [column1, column1 * 10]) FROM (VALUES (1),(2),(3))`.
It panics with "list array" in arrow `as_list`. The pre-fix code was reported to fail with a
length-mismatch error. Here the mixed scalar/array case fails differently, because the scalar
is not expanded.
