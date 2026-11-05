SELECT x, width_bucket(x::numeric, 10, 100, 9) AS num
FROM generate_series(0, 110, 10) x;
SELECT x, width_bucket(x::numeric, 100, 10, 9) AS num
FROM generate_series(0, 110, 10) x;
