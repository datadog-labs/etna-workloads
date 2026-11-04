Writes a parquet file where column `b` has statistics disabled, then reads it back as an external table.
With the bug, missing null-count stats become Exact(num_rows), so the table's stats claim `b` is all null.
Buggy build: `WHERE b = 2` errors ("non-nullable but contains null values"), and `count(b)` returns 0.
Clean build: returns `2` and `count(b)` = 1.
