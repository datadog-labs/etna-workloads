with test AS (SELECT i as c1, i + 1 as c2 FROM generate_series(1, 10) t(i))
select count(*) from test WHERE 1 = 1;

with test AS (SELECT i as c1, i + 1 as c2 FROM generate_series(1, 10) t(i))
select count(c1) from test WHERE 1 = 1;

with test AS (SELECT i as c1, i + 1 as c2 FROM generate_series(1, 5) t(i))
select c2, count(*) from test WHERE 1 = 1 group by c2 order by c2;
