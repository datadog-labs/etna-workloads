Reproducer: `unnest` over a subquery with `LIMIT 1 OFFSET 1` on a list column.

Clean build returns 4, 5, 6. The buggy build returns 1..6, because the single-column, no-NULL fast path in `unnest_list_arrays` returns the whole values buffer of a sliced list array and ignores the offset.
