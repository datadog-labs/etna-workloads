psql -X -q -c "CREATE TABLE pt (a INT) PARTITION BY LIST (a); CREATE TABLE pt1 PARTITION OF pt FOR VALUES IN (1); CREATE INDEX ON pt ((a + 1)); INSERT INTO pt VALUES (1); ANALYZE pt; ANALYZE pt1;"
vacuumdb --analyze-only --missing-stats-only -e -t pt postgres 2>&1 | grep -c 'ANALYZE public.pt'
