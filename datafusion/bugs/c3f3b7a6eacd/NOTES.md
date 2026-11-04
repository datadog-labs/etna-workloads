repro.sql calls `atan2` with integer/NULL arguments and checks the result type and precision.

Clean build: integers are coerced to Float64. `atan2(1,2)` gives 0.4636476090008061, `arrow_typeof(atan2(1,1))` is Float64, and `atan2(1,1000000) = atan2(1.0,1000000.0)` is true.

Buggy build: integers are coerced to Float32. `atan2(1,2)` gives 0.4636476, the type is Float32, and the equality is false.
