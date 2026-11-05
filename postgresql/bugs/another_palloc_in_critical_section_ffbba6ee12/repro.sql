CREATE TABLE array_gin_test (a int[]);
INSERT INTO array_gin_test SELECT ARRAY[1, g%5, g] FROM generate_series(1, 10000) g;
CREATE INDEX array_gin_test_idx ON array_gin_test USING gin (a);
SELECT COUNT(*) FROM array_gin_test WHERE a @> '{2}';
