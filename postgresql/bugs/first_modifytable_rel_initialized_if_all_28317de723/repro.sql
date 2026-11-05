create table part_abc (a int, b text, c bool) partition by list (a);
create table part_abc_1 partition of part_abc for values in (1);
create table part_abc_2 partition of part_abc for values in (2);
insert into part_abc values (1, 'b', true);
insert into part_abc values (2, 'c', true);
create view part_abc_view as select * from part_abc where b <> 'a' with check option;
create function stable_one() returns int as $$ begin return 1; end; $$ language plpgsql stable;
merge into part_abc_view pt
using (select stable_one() + 1 as pid) as q join part_abc_2 pt2 on (q.pid = pt2.a) on pt.a = stable_one() + 2
when not matched then insert values (1, 'd', false) returning pt.a;
table part_abc_view;
