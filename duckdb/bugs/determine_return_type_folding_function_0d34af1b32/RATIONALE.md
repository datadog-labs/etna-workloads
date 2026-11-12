# Rationale

## Hunk: src/function/function_binder.cpp, `FunctionBinder::BindScalarFunction` (NULL-folding path)
Traces to the fix hunk that, for typed NULL constant arguments with an incomplete declared return type, calls
`ResolveScalarFunctionTypes` to determine the NULL constant's type. I removed that call (and the collation
propagation that went with it) and fold to `NullReturnType(return_type)` instead, i.e. the declared return type,
which is SQLNULL for `ANY -> ANY` functions like `||`. This restores the original bug: `NULL::VARCHAR || 'z'`
becomes an untyped NULL, so `repeat(...)` picks the BLOB overload and the type leaks into UNIONs.

(`ResolveScalarFunctionTypes` itself is left in place since `ResolveFunction` still uses it.)

## Oracle
test/sql/function/generic/null_constant_return_type.test is expected to fail (typeof returns "NULL" rather than
VARCHAR etc.). Results of etna-check: see below.

```
FAIL     test/sql/function/generic/null_constant_return_type.test
test/sql/function/generic/null_constant_return_type.test:7
SELECT typeof(repeat(CAST(NULL AS VARCHAR) || 'z', 2));
BLOB <> VARCHAR   (expected VARCHAR, actual BLOB)
1 of 1 oracle units fail
```
