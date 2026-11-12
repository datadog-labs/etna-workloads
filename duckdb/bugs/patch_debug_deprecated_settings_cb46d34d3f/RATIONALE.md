# Rationale

The `debug`/`deprecated` exclusivity checks had since been refactored into `DuckDBSettingsBindData::Includes`, so I changed that helper instead of the original inline conditions.

1. `src/function/table/system/duckdb_settings.cpp`, `DuckDBSettingsBindData::Includes`. This undoes the fix's `duckdb_settings.cpp` hunks (`debug != option->is_debug`, `deprecated != option->is_deprecated`, and the matching extension-settings filters). It goes from `debug == is_debug && deprecated == is_deprecated` back to `(debug || !is_debug) && (deprecated || !is_deprecated)`. With that, `debug := true` returns every setting, debug ones included, rather than only the debug ones. The `debug := false` and `debug := true` result sets then overlap, and so do the `deprecated` ones. `debug := true, deprecated := true` also returns rows. Both the built-in options loop and the extension-settings loop call `Includes`, so both are affected.

2. `src/catalog/default/default_table_functions.cpp`, `duckdb_profiling_settings`. This undoes the fix's hunk that changed the view to `deprecated := false`. I set it back to `deprecated := true`, so the deprecated `profiling_mode` setting shows up in the view again.

I did not touch the header and `config.cpp` hunks that add `is_debug` and `is_deprecated` to `ExtensionOption`. Reverting them would force a full rebuild, and the filtering bug does not need them.

## Oracle results
```
FAIL     test/sql/pragma/profiling/test_duckdb_profiling_settings_function.test
FAIL     test/sql/settings/debug_deprecated_settings.test
2 of 2 oracle units fail
```
The profiling test fails on the extra `profiling_mode` row. The debug/deprecated test fails on the non-empty intersection checks.
