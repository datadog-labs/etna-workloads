create role mvowner;
create table t(i int);
insert into t values (1);
create materialized view mv as select * from t;
create unique index mv_i on mv(i);
alter materialized view mv owner to mvowner;
revoke temporary on database postgres from public;
refresh materialized view concurrently mv;
select * from mv;
