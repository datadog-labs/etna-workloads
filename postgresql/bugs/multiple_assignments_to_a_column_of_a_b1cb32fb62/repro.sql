create domain d as int[];
create table t (f d);
insert into t (f[1], f[2]) values (1,2);
select * from t;
