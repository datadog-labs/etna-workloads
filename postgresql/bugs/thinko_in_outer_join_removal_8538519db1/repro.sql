create table t1 (a int primary key);
create table t2 (a int primary key);
insert into t1 values (1),(2);
insert into t2 values (1);
select t1.a, ss.x from t1 left join t2 on t1.a = t2.a
  left join lateral (select t2.a as x) ss on coalesce(ss.x,0) = 1;
select t1.a from t1 left join t2 on t1.a = t2.a
  left join lateral (select 1 where coalesce(t2.a,0)=1) ss on true;
select t1.a from t1 left join t2 on t1.a = t2.a
  join lateral (select 1 where coalesce(t2.a,0)=1) ss on true;
select t1.a from t1 left join t2 on t1.a = t2.a
  left join lateral (select t2.a as x) ss on true where coalesce(ss.x,0)=1;
select t1.a from t1 left join (select a from t2) t2 on t1.a = t2.a
  left join lateral (select t2.a as x) ss on true where coalesce(ss.x,0)=1;
