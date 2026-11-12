create table test(d date);
insert into test values ('2025-01-11'),('2025-01-12');
select * from test where date_trunc('day', date_add(d, INTERVAL 1 day)) >= '2025-01-12';
