create table t(key int primary key, fruit text);
insert into t values (1,'a') on conflict (key) do update set fruit = excluded.fruit where t.fruit != 'x';
insert into t values (1,'b') on conflict (key) do update set fruit = excluded.fruit where t.fruit != 'x' returning *;
