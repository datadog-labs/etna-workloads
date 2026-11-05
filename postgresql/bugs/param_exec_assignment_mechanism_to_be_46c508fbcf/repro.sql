create table onek(unique1 int, ten int, hundred int);
insert into onek select i, i%10, i%100 from generate_series(0,999) i;
create table int4_tbl(f1 int);
insert into int4_tbl values (0),(1),(5);
select sum(ss.tst::int) from
  onek o cross join lateral (
  select i.ten in (select f1 from int4_tbl where f1 <= o.hundred) as tst,
         pg_sleep(0) as r
  from onek i where i.unique1 = o.unique1 ) ss
where o.ten = 0;
