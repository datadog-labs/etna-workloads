SET datafusion.execution.target_partitions = 4;
CREATE TABLE t AS SELECT * FROM (VALUES (1,'no_foo'),(2,'no_bar'),(3,'no_baz')) AS v(ts, nm);
SELECT
  'foo' AS name,
  COUNT(CASE WHEN prev_value = 'no_bar' AND value = 'no_baz' THEN 1 ELSE NULL END) AS count_rises
FROM (
  SELECT nm AS value, LAG(nm) OVER (ORDER BY ts) AS prev_value
  FROM (SELECT ts, with_metadata(nm, 'k', 'v') AS nm FROM t)
);
