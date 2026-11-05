create table onek(unique1 int primary key);
create table tenk1(thousand int, tenthous int, hundred int);
insert into onek select g from generate_series(0,999) g;
insert into tenk1 select g%1000, g, g%100 from generate_series(0,9999) g;
create index on tenk1(thousand,tenthous);
create index on tenk1(hundred);
vacuum analyze onek; vacuum analyze tenk1;
explain (verbose, costs off)
select t1.unique1, t2.hundred
from onek t1, tenk1 t2
where exists (select 1 from tenk1 t3
              where t3.thousand = t1.unique1 and t3.tenthous = t2.hundred)
      and t1.unique1 < 1;
