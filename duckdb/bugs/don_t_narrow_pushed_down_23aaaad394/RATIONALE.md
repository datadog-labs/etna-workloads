# Rationale

File: src/src/common/multi_file/multi_file_column_mapper.cpp, function `TryCastConstant`.

Fix hunk: replaced `StatisticsPropagator::CanPropagateCast` with `BoundCastExpression::CastIsInvertible`, so a pushed-down constant is not narrowed to the file's physical type.
Today's code has extra guards (`CastIsInvertible`, `MappedCastIsInvertible`, and a cast round-trip check), and `CanPropagateCast` no longer exists. I removed the scalar invertibility check and the round-trip check. Only the nested-type mapping check remains. That brings back the old behaviour: the constant is cast to the file type even when that is lossy, for example 0.1 DOUBLE to FLOAT. The filter then replaces the global one and compares wrongly.

Oracle result:
```
FAIL     test/sql/copy/parquet/parquet_filter_narrowing_cast.test
         test/sql/copy/parquet/parquet_filter_narrowing_cast.test:22
         SELECT COUNT(*) FROM f WHERE c > 0.1;   expected 1, actual 0
1 of 1 oracle units fail
```
