create table a(i int) with (vacuum_truncate=false);
create table b(i int);
insert into a select generate_series(1,10000);
insert into b select generate_series(1,10000);
delete from a; delete from b;
vacuum a, b;
select pg_relation_size('a') > 0 as a_kept, pg_relation_size('b') = 0 as b_truncated;
