create table t(a int primary key);
insert into t select generate_series(1,100000);
create index bi on t using brin(a);
create role u1;
set role u1;
select brin_summarize_new_values('bi');
reset role;
select brin_summarize_new_values('t_pkey');
