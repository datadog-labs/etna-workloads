create table idxpart (a int) partition by range (a);
create index idxpart_a_idx on idxpart (a);
drop index concurrently idxpart_a_idx;
