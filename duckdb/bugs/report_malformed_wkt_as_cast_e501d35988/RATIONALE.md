# Rationale

## Hunk: src/common/operator/cast_operators.cpp, `TryCastToGeometry::Operation`
Traces to the fix's single hunk in the same function (the fix's `#include error_data.hpp` hunk is not needed in today's code, which uses `Geometry::TryFromString`).
The fix added a branch: when `parameters.error_message` is set (TRY_CAST, CSV ignore_errors), malformed WKT is reported through `HandleCastError::AssignError` and `false` is returned. Today's code does this via `Geometry::TryFromString`.
I removed that branch, so the function always calls `Geometry::FromString`, which throws `InvalidInputException` on malformed WKT even when the caller collects errors. This is the pre-fix behaviour: TRY_CAST and CSV `ignore_errors` hit an exception instead of getting NULL or a skipped row.

## Oracle
See the etna-check output below (appended after the run).

```
build ok; running oracle tests ...
FAIL     test/sql/types/geo/geometry_try_cast_malformed.test
         Query unexpectedly failed (test/sql/types/geo/geometry_try_cast_malformed.test:5)
         SELECT TRY_CAST('POINT(1 2' AS GEOMETRY), ...
         INTERNAL Error: Scalar function "__cast" threw an execution error, but the function is not marked as fallible ... Error: Failed to parse geometry: Expected ')' but got end of input at offset 9
1 of 1 oracle units fail
```
