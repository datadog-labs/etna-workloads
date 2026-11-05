begin;
create temp table p (a int, b int) partition by range (a);
create temp table p1 partition of p for values from (0) to (10);
create temp table p2 partition of p for values from (10) to (20);
insert into p values (1, 2);
insert into p values (10, 20);
set enable_partitionwise_join to on;
explain (costs off)
select * from p t1 where exists
  (select 1 from p t2 where t1.a = t2.a and t1.a = 1);
select * from p t1 where exists
  (select 1 from p t2 where t1.a = t2.a and t1.a = 1);
rollback;
