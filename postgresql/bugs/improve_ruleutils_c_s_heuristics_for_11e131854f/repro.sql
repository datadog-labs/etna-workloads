create table pt (a int, b int) partition by list (a);
create table pt1 partition of pt for values in (1);
create table pt2 partition of pt for values in (2);
explain (costs off) select * from pt where a = 1;
