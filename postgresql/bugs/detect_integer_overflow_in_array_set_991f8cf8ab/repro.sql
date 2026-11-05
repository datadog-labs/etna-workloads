\set VERBOSITY sqlstate
create temp table t(pk int, f1 int[]);
insert into t(pk, f1[-2147483648:2147483647]) values (2, '{}');
select count(*) from t;
