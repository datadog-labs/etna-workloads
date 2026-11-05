create table phv_part (a int, b text) partition by list (a);
create table phv_part_1 partition of phv_part for values in (1);
create table phv_part_2 partition of phv_part for values in (2);
explain (costs off)
select * from (select a, b from phv_part) t
  where a = 1
  group by grouping sets (a, b);
