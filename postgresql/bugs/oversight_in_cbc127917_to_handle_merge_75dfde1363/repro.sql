create table part_abc (a int, b text, c bool) partition by list (a);
create table part_abc_1 (b text, a int, c bool);
create table part_abc_2 (a int, c bool, b text);
create table part_abc_3 (a int, b text, c bool);
alter table part_abc attach partition part_abc_1 for values in (1);
alter table part_abc attach partition part_abc_2 for values in (2);
alter table part_abc attach partition part_abc_3 for values in (3);
insert into part_abc values (1,'a',true),(2,'c',true);
create view part_abc_view as select * from part_abc where b <> 'a' with check option;
insert into part_abc values (1,'b',true);
create function stable_one() returns int as $$ begin return 1; end; $$ language plpgsql stable;
merge into part_abc_view pt
using (select stable_one() as pid) as q join part_abc_1 pt1 on (q.pid = pt1.a) on pt.a = pt1.a
when matched then delete returning pt.a;
table part_abc_view;
