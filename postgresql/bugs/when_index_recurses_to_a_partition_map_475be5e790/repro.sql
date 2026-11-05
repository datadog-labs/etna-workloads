create table idxpart (a int, b int) partition by range (a);
create table idxpart1 (x int, a int, b int);
alter table idxpart1 drop column x;
alter table idxpart attach partition idxpart1 for values from (0) to (10);
create table idxpart2 (c int, d int, a int, b int);
alter table idxpart2 drop column c, drop column d;
alter table idxpart attach partition idxpart2 for values from (10) to (20);
create index on idxpart ((b + 1));
select c.relname, pg_get_indexdef(indexrelid) from pg_class c join pg_index i on c.oid = i.indexrelid
  where indrelid::regclass::text like 'idxpart%' order by 1;
