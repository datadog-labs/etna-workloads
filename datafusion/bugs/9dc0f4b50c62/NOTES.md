repro.sql casts empty lists to `FixedSizeList(0, Null)` (including via `empty(...)`) and a string to `FixedSizeList(1, Int64)`.
Clean build returns `true` / `[]` / `[]`,NULL / `[1]`. The buggy build panics on the first query
(BooleanArray index 0 of length 0, exit status 101), because zero-size FixedSizeList scalars are built with length 0.
