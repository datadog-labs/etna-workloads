# Rationale

Fix hunk: `datafusion/spark/src/function/datetime/next_day.rs` removed `.trim()` in
`spark_next_day` (`day_of_week.trim().to_uppercase()` -> `day_of_week.to_uppercase()`).

55.2.0 already contains the post-fix line, at the same place in `spark_next_day`. I
reversed the hunk by putting `.trim()` back, so `day_of_week.trim().to_uppercase()` is
the original code. Whitespace-padded names such as `' MO '` are accepted again, where
Spark treats them as invalid.

Only that line changed. The test hunks of the fix were not touched.

## Oracle

`next_day.slt` fails: `SELECT next_day('2015-01-14'::DATE, ' MO '::string)` returns
`2015-01-19`, and the test expects `NULL`.
