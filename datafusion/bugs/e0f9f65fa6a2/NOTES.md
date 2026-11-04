Reproducer for the UInt64 + signed-integer coercion bug (fixed upstream in #14223).

repro.sql checks the coalesce type, the type of UInt64 + Int64, and a UInt64 = Int64 comparison at u64::MAX.

- df-clean coerces UInt64 with signed integers to Decimal128(20, 0). `coalesce(2, arrow_cast(3,'UInt64'))` has type Decimal128(20, 0). `UInt64 + Int64` has type Decimal128(21, 0). The comparison returns false.
- df-buggy coerces to Int64. The coalesce type is Int64 and `UInt64 + Int64` is Int64. Comparing u64::MAX with -1 fails with "Optimizer rule 'simplify_expressions' failed ... Can't cast value 18446744073709551615 to type Int64".
