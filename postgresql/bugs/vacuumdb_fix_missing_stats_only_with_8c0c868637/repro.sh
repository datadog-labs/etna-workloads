psql -X -q -c "CREATE TABLE t AS SELECT 1 a, 2 b; ALTER TABLE t ADD COLUMN c int GENERATED ALWAYS AS (a+b) VIRTUAL; ANALYZE t;"
vacuumdb --analyze-only --missing-stats-only -t t -v postgres 2>&1 | grep -c 'analyzing'
