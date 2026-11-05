create table idxpart (a int, b int, c int) partition by range (a);
create table idxpart1 partition of idxpart for values from (0) to (10);
create index idxpart_c on only idxpart (c);
create index idxpart1_c on idxpart1 (c);
alter table idxpart_c attach partition idxpart1_c for values from (10) to (20);
select 1 as still_alive;
