SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY v) AS p, arrow_typeof(percentile_cont(0.5) WITHIN GROUP (ORDER BY v)) AS t
FROM (VALUES (arrow_cast(0, 'Float16')), (arrow_cast(65504, 'Float16'))) AS x(v);
