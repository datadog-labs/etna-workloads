create table idxpart (a int primary key, b int) partition by range (a);
create table failpart partition of idxpart (b primary key) for values from (0) to (100);
select count(*) from pg_index where indrelid='failpart'::regclass and indisprimary;
