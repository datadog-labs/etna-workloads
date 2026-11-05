create table t(a int, b int, c int);
alter table t add exclude (a with =) where (b > 0);
alter table t alter column b type bigint;
select conname from pg_constraint where conrelid='t'::regclass;
select indexrelid::regclass from pg_index where indrelid='t'::regclass;
