create table t (a int, b text default 'td', e text);
create view v as select a, b, e from t;
alter view v alter b set default 'vd';
create rule r as on insert to v do also insert into t (a, b, e) select new.a, new.b, 'xxx';
insert into v values (1, default, default);
insert into v values (2, default, default), (3, default, default);
select * from t order by a, e nulls first;
