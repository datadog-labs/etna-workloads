repro.sql runs the three `avg(decimal)` regression queries from the fix's decimal.slt.
Each averages a constant Decimal32, Decimal64 or Decimal128 column over enough rows that the sum exceeds the input's native integer max.
df-clean returns the correct average (e.g. 99999.0000, Decimal32(9, 4)).
df-buggy accumulates the sum in the unwidened type and fails each query with "Execution error: Arithmetic Overflow in AvgAccumulator".
