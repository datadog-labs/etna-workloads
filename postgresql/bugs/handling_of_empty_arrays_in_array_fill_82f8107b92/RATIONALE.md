# Rationale

File: src/backend/utils/adt/arrayfuncs.c, function `array_fill_internal`.
All hunks trace to the fix.patch hunks in the same function (reversed):

1. Dims checks: `ARR_NDIM(dims) > 1` -> `!= 1`, restored the "Lower bound of dimension array must be one" check, and `ndims = ARR_DIMS(dims)[0]` (no ndim==0 guard). Empty `'{}'` dimension arrays are now rejected (or read out of bounds) instead of yielding an empty array.
2. Same for the `lbs` array: `!= 1`, lower-bound check restored, and `ARR_DIMS(lbs)[0] != ndims`.

The later `nitems` / empty-array fast-track hunk was left in its current form. Current code also calls ArrayCheckBounds there, so the original ordering does not apply directly.

Expected failing oracle case: src/test/regress||arrays (empty-array array_fill cases such as `array_fill(1, '{}')`).
Result of the oracle run: src/test/regress||arrays FAILS (1/1 failing).
