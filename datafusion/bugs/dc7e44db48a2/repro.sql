create table t3 (x varchar, y varchar, z varchar);
insert into t3 values ('a', 'b', 'c');
select x, y, z from t3 union all by name select z, y, x from t3;
select t3.x, t3.y, t3.z from t3 union by name select t3.z, t3.y, t3.x, 'd' as zz from t3 order by zz;
