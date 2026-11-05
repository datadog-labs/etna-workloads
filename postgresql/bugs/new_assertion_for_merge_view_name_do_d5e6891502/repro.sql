create table t(a int, b text);
insert into t values (1,'x');
create view v as select * from t;
merge into v using (values (1),(2)) s(a) on v.a=s.a when matched then do nothing;
select 'done';
