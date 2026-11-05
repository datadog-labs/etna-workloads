create table t1(f1 text);
create table t2(f1 text);
create table i8(q1 int8, q2 int8);
insert into i8 values (1,123),(2,456),(3,789);
insert into t1 select 'a' from generate_series(1,5);
insert into t2 values ('a'),('b');
analyze t1; analyze t2; analyze i8;
set enable_hashjoin=off; set enable_mergejoin=off; set enable_material=off;
set enable_seqscan=on;
explain (verbose, costs off)
select * from t1 left join i8 on i8.q2=123,
  lateral (select i8.q1, t2.f1 from t2 limit 1) as ss
where t1.f1 = ss.f1;
