Reproducer calls `round()` on Int64/UInt64 values above 2^53 (and an Int64 overflow case with scale -1).
Clean build keeps the integer type and value (Int64 9007199254740993, UInt64 18446744073709551615, and errors with "Overflow while rounding Int64" for i64::MAX at -1).
Buggy build coerces to Float64: type Float64, value 9007199254740992.0 / 1.8446744073709552e19, and no overflow error (9.223372036854776e18).
