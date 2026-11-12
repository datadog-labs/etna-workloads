# Rationale

## Hunk
`src/include/duckdb/storage/statistics/stats_writer.hpp`, `StatsWriter::Clear()`.
Traces to the fix's `StatsWriter::UpdateMinMax` / `NumericStats::UpdateValue` hunks, which added
"if min > max (unset), set min = max = new_value". In today's code the same problem is solved
differently: for floating point types `Clear()` seeds `min` with NaN (the greatest value in DuckDB ordering),
so a first NaN is never "less than" the seed and min ends up NaN. I reverted that to the
original seed `min = NumericLimits<T>::Maximum()` for all types. Without the "unset" check, a column
holding only NaN keeps min at the type's max instead of NaN, which is the original bug.

## Oracle result
```
FAIL     test/sql/storage/nan_min_statistics.test
         test/sql/storage/nan_min_statistics.test:60 ... Wrong result in query!
         Mismatch on row 1, column isnan(CAST((stats(f)).min AS FLOAT))(index 1)
         0 <> 1
1 of 1 oracle units fail
```
