create table t8(q1 int8, q2 int8);
insert into t8 values (1,2),(3,4);
create function eq2(t t8) returns int8 as $$ select t.q2 $$ language sql immutable;
select x from t8, lateral (select eq2(t8) offset 0) f(x);
select x from t8, lateral (select eq2(t8) from (select 1 offset 0) s offset 0) f(x);
