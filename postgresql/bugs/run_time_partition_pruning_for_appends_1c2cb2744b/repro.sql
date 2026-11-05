create table ab (a int, b int) partition by list (a);
create table ab_a1 partition of ab for values in (1) partition by list (b);
create table ab_a1_b1 partition of ab_a1 for values in (1);
create table ab_a1_b2 partition of ab_a1 for values in (2);
create table ab_a2 partition of ab for values in (2);
insert into ab values (1,1),(1,2),(2,1),(2,2);
select * from (select * from ab where a = 1 union all select * from ab) ab where b = (select 1) order by 1,2;
explain (analyze, costs off, summary off, timing off)
select * from (select * from ab where a = 1 union all select * from ab) ab where b = (select 1);
