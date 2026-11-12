# Rationale

The upstream hunk (`Value::ToSQLString` appending `::TYPE` to typed NULLs) is already in today's
code, but reverting it verbatim gives no failure. Macro default parameters are no longer rendered
through `Value::ToSQLString`. They go through `ConstantExpression::FromValue`
(`src/parser/expression/value_expression.cpp`), which now emits `CAST(NULL AS type)`.
That is the same "keep type info on a typed NULL" logic.

## Hunk
- `src/parser/expression/value_expression.cpp`, `ValueExpression::FromValue` (the `value.IsNull()` branch).
  Maps to the fix's single hunk (typed NULL stringified with its type). The branch used to return
  `Null()` for SQLNULL and `CastTo(type, Null())` otherwise. It now returns plain `Null()` for
  every type, so the type is lost, as it was before the fix.

## Result
```
FAIL     test/sql/export/export_typed_null.test
         test/sql/export/export_typed_null.test:20
         SELECT typeof(typed_null()), typed_null() IS NULL;
         "NULL" <> INTEGER
1 of 1 oracle units fail
```
