SELECT sum(x) over (rows between current row and 9223372036854775807 following exclude current row), x
FROM generate_series(1,5) x;
SELECT sum(x) over (rows between 9223372036854775807 following and 1 following), x
FROM generate_series(1,5) x;
SELECT sum(x) over (rows between current row and 9223372036854775807 following), x
FROM generate_series(1,5) x;
SELECT last_value(x) over (order by x rows between current row and 9223372036854775807 following exclude current row), x
FROM generate_series(1,5) x;
