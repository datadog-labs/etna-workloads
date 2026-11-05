create table t (a int, b text default 'Table default');
create view v as select * from t;
insert into v values (1, default), (2, default);
select * from t order by a;
