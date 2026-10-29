repro.sql: a table with a STORED generated NOT NULL column depending on a NOT NULL DEFAULT column; REPLACE with NULL for that column.
Clean: `aaa|ccc|ccc`. Buggy: generated columns are not recomputed after the REPLACE default fires (NOT NULL error or wrong value).
