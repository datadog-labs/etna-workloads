create table p (a int, b int) partition by list (a);
create table p1 partition of p for values in (1);
create table p2 partition of p for values in (2);
create table p3 partition of p for values in (3);
prepare q(int) as select * from p where a = $1 and b = (select 1);
set plan_cache_mode = force_generic_plan;
explain (costs off) execute q(1);
explain (costs off, format json) execute q(1);
