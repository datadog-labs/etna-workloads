# Rationale

Hunk: src/planner/binder/statement/bind_copy.cpp, `Binder::BindCopyOptions(CopyInfo&, const CopyFunction&)`.
Traces to the fix's `bind_copy.cpp` hunk that picks `IdentifierConversionPolicy::ALLOW` for column-list
options (partition_by, force_quote, force_not_null, force_null). Today's code computes `is_column_list`
from the option's declared type; I removed that and always pass `FOLLOW_SETTING`. COPY column-list options
are therefore subject to `table_function_identifier_conversion` again. With DEFAULT they log a deprecation
warning, and with DISABLE_IMPLICIT_STRING they throw. This is the pre-fix behaviour.

Oracle: test/sql/copy/copy_column_identifier_conversion.test (see the etna-check output for the result).

## Result
```
build ok; running oracle tests ...
FAIL     test/sql/copy/copy_column_identifier_conversion.test
         test/sql/copy/copy_column_identifier_conversion.test:23 :: Query unexpectedly failed!
         COPY (SELECT 42 i, getvariable('p') AS p) TO '.../copy_columns_DEFAULT' (FORMAT parquet, PARTITION_BY p, OVERWRITE);
         Invalid Input Error: Deprecated implicit conversion of unbound identifiers to strings in table function arguments detected. Please use a string literal instead, e.g. 'p'.
1 of 1 oracle units fail
```
