`repro.sql` runs `array_concat` on mixed List/LargeList/FixedSizeList arguments (the cases added to array_concat.slt by the fix).

- df-clean: each query returns the concatenated LargeList, e.g. `[1, 2, 3, 4]`, and the first query's `arrow_typeof` is `LargeList(Int64)`.
- df-buggy: each query fails with `Internal error: could not cast array of type List(Int64) to GenericListArray<i64>`, because `coerce_types` leaves the outer `List` container unwidened.
