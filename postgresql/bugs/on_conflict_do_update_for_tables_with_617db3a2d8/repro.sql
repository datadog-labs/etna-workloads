create table t(key int primary key, data text, dropme int, x int);
alter table t drop column dropme;
insert into t values(1,'a',1);
insert into t values(1,'b') on conflict (key) do update set data = excluded.data returning *;
create table p(key int primary key, data text) partition by range(key);
create table p1 partition of p for values from (0) to (10);
insert into p values(1,'a');
insert into p values(1,'b') on conflict (key) do update set data = excluded.data returning *;
insert into p values(1,'c') on conflict (key) do update set data = excluded.data, key=2 returning *;
