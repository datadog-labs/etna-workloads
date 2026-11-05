create table idxpart (a int, b text) partition by range (a);
create table idxpart1 partition of idxpart for values from (0) to (100000);
create index idxpart_spgist on idxpart using spgist(b);
explain (costs off) select * from idxpart where b = 'abcd';
