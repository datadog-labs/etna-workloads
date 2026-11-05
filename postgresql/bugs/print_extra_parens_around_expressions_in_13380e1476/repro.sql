create table t (a int, b text);
create statistics s on (a * 2), (a || b) from t;
select pg_get_statisticsobjdef(oid) from pg_statistic_ext where stxname='s';
