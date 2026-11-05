create temp table a as select g as u, g%2 as two from generate_series(1,10) g;
create temp table b as select g as u, g%2 as two from generate_series(1,10) g;
analyze a; analyze b;
set enable_nestloop=off; set enable_mergejoin=off;
explain (costs off)
select * from a t1 join b t2 on t1.two=t2.two and t1.u = (select u from a x where x.u = t2.u);
select count(*) from a t1 join b t2 on t1.two=t2.two and t1.u = (select u from a x where x.u = t2.u);
