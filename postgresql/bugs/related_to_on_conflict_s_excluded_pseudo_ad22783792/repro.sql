create table syscolconflicttest(key int4, data text);
insert into syscolconflicttest values (1);
insert into syscolconflicttest values (1) on conflict (key) do update set data = excluded.ctid::text;
drop table syscolconflicttest;
