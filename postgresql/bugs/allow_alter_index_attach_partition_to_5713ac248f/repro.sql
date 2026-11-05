create table idxpart (a int, b int) partition by range (a);
create table idxpart1 partition of idxpart for values from (0) to (500);
create index on only idxpart ((a/b));
insert into idxpart1 values (1, 0);
create index concurrently on idxpart1 ((a/b));
alter index idxpart_expr_idx attach partition idxpart1_expr_idx;
delete from idxpart1 where b = 0;
reindex index concurrently idxpart1_expr_idx;
alter index idxpart_expr_idx attach partition idxpart1_expr_idx;
select relname, indisvalid from pg_class join pg_index on indexrelid = oid
   where relname like 'idxpart%' order by relname;
