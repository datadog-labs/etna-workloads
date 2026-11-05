CREATE TABLE t(a timestamptz);
INSERT INTO t SELECT '4713-01-01 BC'::timestamptz + (i || ' seconds')::interval FROM generate_series(1,10) s(i);
INSERT INTO t SELECT '294276-12-01 00:00:01'::timestamptz + (i || ' seconds')::interval FROM generate_series(1,30) s(i);
CREATE INDEX ON t USING brin (a timestamptz_minmax_multi_ops) WITH (pages_per_range=1);
SELECT count(*) FROM t;
