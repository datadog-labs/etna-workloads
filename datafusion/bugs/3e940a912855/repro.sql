SET datafusion.execution.target_partitions = 4;
CREATE TABLE t AS SELECT * FROM (VALUES ('no_foo'), ('no_bar'), ('no_baz')) v(c);
CREATE VIEW m AS SELECT with_metadata(arrow_cast(c, 'Utf8'), 'metadata_key', 'the nonnull_name field') AS nonnull_name FROM t;
SELECT name FROM (
  SELECT nonnull_name AS name FROM m
  UNION ALL
  SELECT NULL::string AS name
) GROUP BY name ORDER BY name;
SELECT name FROM (
  SELECT NULL::string AS name
  UNION ALL
  SELECT nonnull_name AS name FROM m
  UNION ALL
  SELECT NULL::string AS name
) GROUP BY name ORDER BY name;
