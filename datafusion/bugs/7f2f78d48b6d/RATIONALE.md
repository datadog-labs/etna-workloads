# Rationale

All changes are in `datafusion/functions-aggregate/src/average.rs`. 55.2.0 still had the fix's
`count == 0 -> None` guards (the decimal accumulator had been refactored into a generic
accumulator with an `avg_fn` closure), so the fix's hunks were reverted by removing the guards:

1. `AvgAccumulator::evaluate` (fix hunk 1): back to `Ok(Float64(self.sum.map(|f| f / self.count as f64)))`.
   After `retract_batch` empties the frame, `sum` stays `Some(..)` and this yields NaN.
2. Generic decimal avg accumulator `evaluate` (fix hunk 2, `DecimalAvgAccumulator`, now using `avg_fn`):
   back to `self.sum.map(|v| (self.avg_fn)(v, self.count)).transpose()?`, so count == 0 divides by zero.
3. `DurationAvgAccumulator::evaluate` (fix hunk 3): back to `self.sum.map(|sum| sum / self.count as i64)`.

## Oracle
`window.slt` fails: the Decimal(10,2) sliding-window AVG query panics with "attempt to divide by zero".
The Float64 case would give NaN instead of NULL.
