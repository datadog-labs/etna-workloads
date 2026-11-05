create table t (a int);
alter table t add unique (a);
select conname, contype from pg_constraint where conrelid='t'::regclass;
