Reproducer: builds a one-row table with mixed signed/unsigned integer columns and checks `arrow_typeof` and values of arithmetic between them.
Clean: UInt32+Int32 -> Int64, UInt16+Int8 -> Int32, UInt64+Int64 -> Decimal128(21,0), UInt64*Int8 -> Decimal128(38,0), and UInt64/Int64 prints 1.0000.
Buggy: the same expressions coerce to Int32/Int8/Int64/Int8 (narrower or lossy types), and UInt64/Int64 prints 1.
