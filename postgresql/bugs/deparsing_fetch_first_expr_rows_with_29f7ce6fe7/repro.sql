CREATE VIEW v1 AS SELECT g FROM generate_series(1,10) g ORDER BY g FETCH FIRST (5::bigint) ROWS WITH TIES;
SELECT pg_get_viewdef('v1'::regclass);
