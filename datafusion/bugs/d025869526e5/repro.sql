SET datafusion.execution.parquet.pushdown_filters = true;
SET datafusion.execution.parquet.reorder_filters = true;
SET datafusion.optimizer.enable_dynamic_filter_pushdown = true;
SET datafusion.optimizer.enable_join_dynamic_filter_pushdown = true;

COPY (
  SELECT to_timestamp_nanos(time_ns) AS time,
    arrow_cast(state, 'Dictionary(Int32, Utf8)') AS state,
    arrow_cast(city, 'Dictionary(Int32, Utf8)') AS city, temp
  FROM (VALUES (200,'CA','LA',90.0),(250,'MA','Boston',72.4),(100,'MA','Boston',70.4),(350,'CA','LA',90.0)) AS t(time_ns,state,city,temp)
) TO 'h2o.parquet';

COPY (
  SELECT to_timestamp_nanos(time_ns) AS time,
    arrow_cast(state, 'Dictionary(Int32, Utf8)') AS state,
    arrow_cast(city, 'Dictionary(Int32, Utf8)') AS city, temp, reading
  FROM (VALUES (250,'MA','Boston',53.4,51.0),(100,'MA','Boston',50.4,50.0)) AS t(time_ns,state,city,temp,reading)
) TO 'o2.parquet';

CREATE EXTERNAL TABLE h2o STORED AS PARQUET LOCATION 'h2o.parquet';
CREATE EXTERNAL TABLE o2 STORED AS PARQUET LOCATION 'o2.parquet';

SELECT h2o.temp AS h2o_temp, o2.temp AS o2_temp, o2.reading
FROM h2o INNER JOIN o2
  ON h2o.time = o2.time AND h2o.state = o2.state AND h2o.city = o2.city
WHERE h2o.time >= '1970-01-01T00:00:00.000000050Z'
  AND h2o.time <= '1970-01-01T00:00:00.000000300Z'
ORDER BY h2o_temp;
