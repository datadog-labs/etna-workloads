create table rp (a int, b int, c int, d int) partition by range(a, b, c, d);
create table rp_p1 partition of rp for values from (1, 1, 1, 0) to (1, 1, 1, 10);
create table rp_p2 partition of rp for values from (2, 2, 2, 0) to (2, 2, 2, 10);
explain (costs off) select * from rp where a >= 1 and b >= 1 and b = 2 and c = 2 and d >= 0;
