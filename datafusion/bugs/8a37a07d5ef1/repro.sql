SELECT to_date(NULL::VARCHAR, '%Y-%m-%d');
SELECT to_date('2020-09-08', NULL::VARCHAR, NULL::VARCHAR);
SELECT to_timestamp(NULL::VARCHAR, '%Y-%m-%d');
SELECT to_unixtime('2020-09-08', NULL::VARCHAR, NULL::VARCHAR);
SELECT id, to_timestamp(value, format1, format2)
FROM (
  VALUES
    (1, '2020-09-08', NULL::VARCHAR, '%Y-%m-%d'),
    (2, '2020-09-08', NULL::VARCHAR, NULL::VARCHAR)
) AS t(id, value, format1, format2)
ORDER BY id;
