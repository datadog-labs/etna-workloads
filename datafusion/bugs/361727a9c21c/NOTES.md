repro.sql creates a one-row table and runs `concat_ws('', a, b, 'c')` (empty delimiter, mixed column/literal args), plus an EXPLAIN.
Clean build simplifies to `concat(a, b, c)` and returns `abc`. Buggy build leaves `concat_ws(a, b, c)` (the first arg is treated as the separator), returning `bac`.
