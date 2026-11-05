# Rationale

File: src/backend/statistics/attribute_stats.c

- `attribute_statistics_update()`: removed the `attnum < 0` check ("cannot modify statistics on system column"). Traces to the first hunk of fix_impl.patch. Without it, statistics can be modified on system columns.
- `pg_clear_attribute_stats()`: removed the `attnum < 0` check ("cannot clear statistics on system column"). Traces to the second hunk. Without it, statistics on system columns can be cleared.

Failing oracle case: src/test/regress||stats_import
