create temp table t1(f1 int);
create temp table t2(f1 bigint);
create temp view v1 as select f1::int from t1 left join t2 using (f1) group by f1;
select pg_get_viewdef('v1'::regclass);
