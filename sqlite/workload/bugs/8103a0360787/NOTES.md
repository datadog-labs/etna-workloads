repro.sql LEFT JOINs two generate_series() table-valued functions with an ON clause.
Clean shell: prints `1|4`, `2|5`, `3|` (exit 0).
Buggy shell: `first argument to "generate_series()" missing or unusable` (exit 1), because the
table-function argument terms are no longer marked as LEFT JOIN terms (sqlite3SetJoinExpr missing).
