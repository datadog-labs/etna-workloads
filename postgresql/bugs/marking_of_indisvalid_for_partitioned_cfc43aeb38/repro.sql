create table t (a int, b int) partition by range (a);
create table t_1 partition of t for values from (1) to (10) partition by range (a);
create table t_2 partition of t for values from (10) to (20);
create table t_11 partition of t_1 for values from (1) to (5);
create table t_12 partition of t_1 for values from (5) to (10);
insert into t_11 values (1, 0);
create index concurrently t_idx_11 on t_11 ((a/b));
create index t_idx on t ((a/b));
select indexrelid::regclass, indisvalid from pg_index
 where indexrelid::regclass::text like 't\_%' or indexrelid::regclass::text='t_idx'
 order by indexrelid::regclass::text collate "C";
