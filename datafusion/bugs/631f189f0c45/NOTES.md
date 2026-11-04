Reproducer: the query from the fix's decimal.slt record (`numeric / bigint` inside a WHERE clause, over a 3-row BIGINT table).

Clean build: returns 3 rows.
Buggy build: fails with `Internal error: Assertion failed ... Intervals must have the same data type for division` (Decimal128(38,10) vs Decimal128(20,0)). Interval propagation no longer coerces the operand types.
