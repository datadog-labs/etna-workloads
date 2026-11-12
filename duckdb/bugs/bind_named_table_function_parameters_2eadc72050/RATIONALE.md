# Rationale

## Hunk
`src/function/function_binder.cpp`, `PlaceOption`: `value.TryCastAs(context, option.type, &error_message)` became `value.DefaultTryCastAs(option.type, &error_message)`.

Traces to the fix's change in `Binder::BindNamedParameters` (`DefaultCastAs` -> `CastAs(context, ...)`).

In today's code `Binder::BindNamedParameters` no longer exists. Named-argument casting moved into `FunctionBinder`, and typed named options (such as read_csv `names`) are cast in `PlaceOption`. The fix replaced the built-in-only cast with the context-aware one. This change goes back to the built-in-only cast, so the cast set never reaches ICU's casts, and a TIMESTAMPTZ cast to VARCHAR prints in UTC.

Only `PlaceOption` was changed. `PlaceArgument` and `CastToParameterType` also serve positional parameters, which were correct before the fix, so they stay as they are.

## Oracle result
```
FAIL     test/sql/binder/named_parameter_cast.test
         Wrong result in query! (test/sql/binder/named_parameter_cast.test:18)!
         Mismatch on row 1, column column_name(index 1)
         2024-01-01 12:00:00+00 <> 2024-01-01 04:00:00-08
1 of 1 oracle units fail
```
