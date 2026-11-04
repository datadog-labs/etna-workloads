repro.sql calls `nanvl` with integer/NULL arguments and checks result types and values.

Clean build: `nanvl(1, 2)` and `nanvl(null, null)` return Float64, and `nanvl(16777217, 1)` returns 16777217.0.
Buggy build: integers are coerced to Float16/Float32 (types Float32 and Float16 above). `nanvl(16777217, 1)` is rounded to 16777216.0, so the equality checks print false.
