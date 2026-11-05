SELECT '2202020-10-05'::date > '2020-10-05'::timestamp as t;
SELECT '2020-10-05'::timestamp > '2202020-10-05'::date as f;
SELECT '2202020-10-05'::date > '2020-10-05'::timestamptz as t;
