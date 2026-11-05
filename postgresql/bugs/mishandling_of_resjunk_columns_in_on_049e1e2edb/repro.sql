create table upsert_multi (a int primary key, b int, c int, d int);
insert into upsert_multi values (1, 10, 20, 30);
insert into upsert_multi values (1, 0, 0, 0)
  on conflict (a) do update set (b, c) = (select upsert_multi.d + 1, upsert_multi.d + 2);
select * from upsert_multi;
insert into upsert_multi values (1, 0, 0, 0)
  on conflict (a) do update set (b, c) = (select upsert_multi.d, 5), d = 7;
select * from upsert_multi;
