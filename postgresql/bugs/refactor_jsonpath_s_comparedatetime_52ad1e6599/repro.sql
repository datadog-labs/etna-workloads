set time zone '+00';
select jsonb_path_query('"1000000-01-01"', '$.datetime() > "2020-01-01 12:00:00".datetime()'::jsonpath);
select jsonb_path_query_tz('"1000000-01-01"', '$.datetime() > "2020-01-01 12:00:00+01".datetime()'::jsonpath);
