create function stable_one() returns int as $$ begin return 1; end; $$ language plpgsql stable;
create table part_abc (a int, b text, c bool) partition by list (a);
create table part_abc_1 partition of part_abc for values in (1);
create table part_abc_2 partition of part_abc for values in (2);
create index on part_abc (a);
alter table part_abc add d int;
create table part_abc_3 partition of part_abc for values in (3, 4) partition by range (d);
create table part_abc_3_1 partition of part_abc_3 for values from (minvalue) to (1);
create table part_abc_3_2 partition of part_abc_3 for values from (1) to (100);
create table part_abc_3_3 partition of part_abc_3 for values from (100) to (maxvalue);
explain (costs off)
select min(a) over (partition by a order by a) from part_abc where a >= stable_one() + 1 and d <= stable_one()
union all
select min(a) over (partition by a order by a) from part_abc where a >= stable_one() + 1 and d >= stable_one();
