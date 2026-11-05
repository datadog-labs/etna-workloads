create table tenk1 as select i as unique1, (i*7919)%10000 as unique2, i%10 as ten, i%100 as hundred, i%1000 as thousand from generate_series(0,9999) i;
create unique index tenk1_unique1 on tenk1(unique1);
create unique index tenk1_unique2 on tenk1(unique2);
create index tenk1_hundred on tenk1(hundred);
vacuum analyze tenk1;
set enable_hashjoin=off; set enable_mergejoin=off;
explain (costs off)
select * from tenk1 t1 left join
  (tenk1 t2 join tenk1 t3 on t2.thousand = t3.unique2)
  on t1.hundred = t2.hundred and t1.ten = t3.ten
where t1.unique1 = 1;
