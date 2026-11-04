# Rationale

Fix: array functions must follow SQL null semantics for null index/count args.

## Changes
1. `functions-nested/src/extract.rs` `general_array_element`: dropped the explicit
   `indexes.is_null(row_index)` check (fix hunk `array or index is null`). A null
   index slot now reads whatever value sits in the Arrow buffer, so the result
   depends on buffer contents instead of being NULL.
2. `functions-nested/src/remove.rs` `ArrayRemoveN::invoke_with_args`: reverted
   - the scalar path: null `max` returns the input list unchanged (instead of an all-NULL array);
   - the array path: null `max` entries are mapped to `0` (instead of `None`, which
     `general_remove` turns into a NULL row).
   `general_remove` already takes `&[Option<i64>]`, so `Some(0)` reproduces the old `0` count.

## Oracle failures expected
`array_remove.slt` fails (confirmed): `array_remove_n` with NULL max returns the original array instead of NULL.
