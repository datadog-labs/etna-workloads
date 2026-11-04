# Rationale

Fix hunk reversed: the `Plus | Minus if is_time_interval_arithmetic(...)` arm in
`BinaryTypeCoercer::signature` and its helper `is_time_interval_arithmetic`
(datafusion/expr-common/src/type_coercion/binary.rs). Both are removed, so
`time ± interval` again falls into the generic `Plus | Minus | ...` arm, which
widens the time operand to an Interval and returns an `Interval` (pre-fix behaviour).

The physical-expr hunk (`apply_time_interval`) is left in place: it is now
unreachable for these types, because coercion no longer yields (time, interval) operands.

Oracle: arith_time_interval.slt fails (22 errors): `time + interval` / `time - interval`
return `Interval(MonthDayNano)` (e.g. `25 hours`, `-1 hours`) instead of a wrapped `time`
(`01:00:00`, `23:00:00`), and `arrow_typeof` reports Interval instead of Time unit types.
