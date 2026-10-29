repro.sql: creates a view and a trigger whose WHERE/WHEN expressions contain an "AND 0"
that SQLite optimizes away, then runs ALTER TABLE RENAME and prints the stored SQL.

Clean shell: the optimized-out branches are still renamed (`c=1 AND 0`, `FROM "xyz"`).
Buggy shell: ALTER TABLE skips them, so the view and trigger keep the old names
(`a=1 AND 0`, `FROM v0`), leaving the schema inconsistent.
