create table t(mr int4multirange);
insert into t select int4multirange(int4range(g, g+10000)) from generate_series(1,200) g;
insert into t select int4multirange(int4range(g*10, g*20, '(]'), int4range(g*20, NULL, '(]')) from generate_series(1,100) g;
analyze t;
select count(*) from t where mr <@ int4range(10,50);
